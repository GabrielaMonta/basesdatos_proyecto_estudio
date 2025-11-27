USE proyecto_elecciones;
GO

---------------------------------------------------------------------------
			-- 1. Transacciones en mesa de votacion --
---------------------------------------------------------------------------
-- ============================================================================
-- Objetivo: Registrar Voto en Mesa de Votación (con transacción segura)
-- Aspectos a tener en cuenta:
--  * El token debe existir.
--  * Debe pertenecer a la mesa correcta (mesa_votacion_id).
--  * Debe NO estar usado (usado = 0).
--  * Si todo es válido → se inserta el voto.
--  * Luego se marca token como usado = 1.
--  * Si algo falla → ROLLBACK.
-- ============================================================================

CREATE OR ALTER PROCEDURE sp_RegistrarVoto
    @TokenId INT,
    @ListaId INT,
    @MesaVotacionId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;


        -- 1) Verificar que el token exista
        IF NOT EXISTS (
            SELECT 1
            FROM token_votante
            WHERE token_id = @TokenId
        )
        BEGIN
            RAISERROR('El token no existe.', 16, 1);
        END;


        -- 2) Verificar que el token no haya sido usado
        IF EXISTS (
            SELECT 1
            FROM token_votante
            WHERE token_id = @TokenId
              AND usado = 1
        )
        BEGIN
            RAISERROR('El token ya fue utilizado. No puede votar nuevamente.', 16, 1);
        END;

        
        -- 3) Verificar que la lista exista (incluye voto en blanco)
        IF NOT EXISTS (
            SELECT 1
            FROM lista
            WHERE lista_id = @ListaId
        )
        BEGIN
            RAISERROR('La lista seleccionada no existe.', 16, 1);
        END;

        -- 4) Insertar el voto en la tabla voto
        INSERT INTO voto (token_id, lista_id, mesa_votacion_id)
        VALUES (@TokenId, @ListaId, @MesaVotacionId);


        -- 5) Actualizar token a usado = 1
        UPDATE token_votante
        SET usado = 1
        WHERE token_id = @TokenId;


        -- 6) Si todo es correcto, entonces se guardan los cambios
        COMMIT TRAN;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        DECLARE @Mensaje NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@Mensaje, 16, 1);
    END CATCH
END;
GO


---------------------------------------------------------------------------
		  -- 3. Prueba de emision de voto --
---------------------------------------------------------------------------
-- Buscamos un token valido:
SELECT TOP 1 token_id, usado 
FROM token_votante
WHERE usado = 0;

--token id 31 registrado en la transaccion de mesa de identificacion
--tenemos 2 listas con id 1 y 2

--Caso exitoso: registro del voto
EXEC sp_RegistrarVoto 
    @TokenId = 31,
    @ListaId = 1,
    @MesaVotacionId = 1;


--Caso de fallo 1: volvemos a intentar registrar un voto con el token anterior
EXEC sp_RegistrarVoto 31, 1, 1;


--Caso de fallo 2: queremos votar con un token que no existe
EXEC sp_RegistrarVoto 9999, 1, 1;


--Caso de fallo 3: queremos votar a una lista no existente
EXEC sp_RegistrarVoto 
    @TokenId = 32,
    @ListaId = 33,
    @MesaVotacionId = 1;

---------------------------------------------------------------------------
		                -- 4. Verificaciones --
---------------------------------------------------------------------------
SELECT * FROM voto WHERE token_id = 31;
SELECT usado FROM token_votante WHERE token_id = 31;

SELECT * FROM voto WHERE token_id = 32;
SELECT usado FROM token_votante WHERE token_id = 32;


---------------------------------------------------------------------------
		                -- 5. Conclusiones --
---------------------------------------------------------------------------
-- En la mesa de votación se implementó una transacción que garantiza la integridad del sufragio.
-- Primero se valida que el token exista y que no haya sido utilizado previamente. 
--  Caso favorable:
--      * si las condiciones se cumplen, el sistema registra el voto y luego actualiza el token marcándolo como usado=1.
--  Caso erroneo:
--      * cualquier error durante el proceso activa el mecanismo de rollback, evitando votos duplicados o 
--        registros inconsistentes. 
-- Esta transacción asegura que cada votante emita exactamente un voto y que ningún token pueda ser reutilizado.
