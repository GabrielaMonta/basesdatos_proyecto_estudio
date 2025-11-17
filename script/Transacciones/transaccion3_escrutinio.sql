USE proyecto_elecciones;
GO

-- ============================================================================
-- Objetivo: Generar Escrutinio con Transacciones Anidadas (SAVEPOINT)
--
-- Aspectos a tener en cuenta:
--  * Recalcular el escrutinio por mesa.
--  * Usa SAVEPOINT para que si una mesa falla, no afecte a las demás.
--  * Si falla el escrutinio general, se hace ROLLBACK total.
--  * Si todo es exitoso, se genera el resultado final.
-- ============================================================================

CREATE OR ALTER PROCEDURE sp_GenerarEscrutinio
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;


        -- 1. Limpiar el escrutinio anterior
        DELETE FROM escrutinio_mesa;


        -- 2. Recalcular escrutinio mesa por mesa con SAVEPOINT
        DECLARE @MesaId INT;

        DECLARE cursorMesas CURSOR FOR
            SELECT mesa_votacion_id
            FROM mesa_votacion;

        OPEN cursorMesas;
        FETCH NEXT FROM cursorMesas INTO @MesaId;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SAVE TRAN saveMesa;

            BEGIN TRY
                INSERT INTO escrutinio_mesa (lista_id, mesa_votacion_id, cantidad_votos)
                SELECT lista_id, mesa_votacion_id, COUNT(*)
                FROM voto
                WHERE mesa_votacion_id = @MesaId
                GROUP BY lista_id, mesa_votacion_id;
            END TRY
            BEGIN CATCH
                -- Si falla solo esta mesa → rollback parcial
                ROLLBACK TRAN saveMesa;
            END CATCH

            FETCH NEXT FROM cursorMesas INTO @MesaId;
        END

        CLOSE cursorMesas;
        DEALLOCATE cursorMesas;


        -- 3. Generar resultado total por lista
        DELETE FROM resultado_eleccion;

        INSERT INTO resultado_eleccion (lista_id, eleccion_id, resultado)
        SELECT 
            lista_id,
            1 AS eleccion_id,
            SUM(cantidad_votos)
        FROM escrutinio_mesa
        GROUP BY lista_id;


        -- 4. Commit final
        COMMIT TRAN;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        DECLARE @Err NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@Err, 16, 1);
    END CATCH
END;
GO


---------------------------------------------------------------------------
		             -- 2. Prueba de escrutinio --
---------------------------------------------------------------------------
EXEC sp_GenerarEscrutinio;


---------------------------------------------------------------------------
		                -- 3. Verificaciones --
---------------------------------------------------------------------------
SELECT * FROM escrutinio_mesa ORDER BY mesa_votacion_id;
SELECT * FROM resultado_eleccion ORDER BY lista_id;


---------------------------------------------------------------------------
		             -- 4. Crear escenario de error --
-- Preparamos el escenario fallido sin alterar los datos reales del script base
---------------------------------------------------------------------------

-- a. Creamos una mesa de votacion vacia
INSERT INTO mesa_votacion (nro_mesa_votacion)
VALUES (99); -- mesa vacía para pruebas

SELECT * FROM mesa_votacion;

-- b. Ejecutamos nuevamente la transaccion
EXEC sp_GenerarEscrutinio;


-- c. Verificar como queda el escrutinio
SELECT * FROM escrutinio_mesa ORDER BY mesa_votacion_id;

--RESULTADO ESPERADO:
--Mesa 1 → OK
--Mesa 2 → OK
--Mesa 99 → NO aparece (rollback parcial aplicado)

-- d. Ver resultado final
SELECT * FROM resultado_eleccion;

--- Para no ensuciar la base 
--DELETE FROM mesa_votacion WHERE nro_mesa_votacion = 99;


---------------------------------------------------------------------------
		                -- 5. Conclusiones --
---------------------------------------------------------------------------
-- El procedimiento sp_GenerarEscrutinio implementa una transacción anidada con SAVEPOINT que permite recalcular el 
-- escrutinio por mesa de forma segura y tolerante a fallos.
--  * Si el cálculo de una mesa presenta un error, solo se revierte esa porción de la transacción, permitiendo 
--    continuar con el resto del proceso sin afectar la integridad general.
--  * Solo al finalizar exitosamente todo el recuento se genera el resultado final de la elección y se confirma 
--    mediante COMMIT.

-- La prueba con una mesa vacía (mesa 99) permitió evidenciar que el SAVEPOINT funciona correctamente, descartando 
-- únicamente el procesamiento de esa mesa sin detener el escrutinio completo.

-- Este enfoque demuestra el uso adecuado de transacciones simples, transacciones anidadas y mecanismos de 
-- rollback parcial aplicados a un proceso crítico en un sistema de votación electrónica.