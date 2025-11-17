use proyecto_elecciones
go

---------------------------------------------------------------------------
			-- 1. Transacciones en mesa de identificacion --
---------------------------------------------------------------------------
-- ========================================================================
-- Objetivo: Registrar estudiante en mesa de identificación (con transacción)
-- Aspectos a tener en cuenta:
--  * El estudiante debe existir.
--  * Debe ser REGULAR (estado_id = 1 en carrera_estudiante).
--  * No debe estar ya asignado a otra mesa en la misma elección.
--  * Si todo ok: se lo asigna a la mesa y se le genera un token.
-- ========================================================================

CREATE OR ALTER PROCEDURE sp_RegistrarEnMesaIdentificacion
    @DocumentoEstudiante INT,
    @MesaIdentificacionId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;


        -- 1) Verificar que el estudiante exista
        IF NOT EXISTS (
            SELECT 1
            FROM estudiante
            WHERE documento_estudiante = @DocumentoEstudiante
        )
        BEGIN
            RAISERROR('El estudiante no existe.', 16, 1);
        END;
       

        -- 2) Verificar que el estudiante sea REGULAR (estado_id = 1)
        IF NOT EXISTS (
            SELECT 1
            FROM carrera_estudiante
            WHERE documento_estudiante = @DocumentoEstudiante
              AND estado_id = 1
        )
        BEGIN
            RAISERROR('El estudiante no es Regular. No puede votar.', 16, 1);
        END;


        -- 3) Verificar que no esté registrado en otra mesa para la MISMA elección
        DECLARE @EleccionId INT;

        SELECT @EleccionId = eleccion_id
        FROM mesa_identificacion
        WHERE mesa_identificacion_id = @MesaIdentificacionId;

        IF EXISTS (
            SELECT 1
            FROM mesa_identificacion_estudiante mie
            JOIN mesa_identificacion mi ON mi.mesa_identificacion_id = mie.mesa_identificacion_id
            WHERE mie.documento_estudiante = @DocumentoEstudiante
              AND mi.eleccion_id = @EleccionId
        )
        BEGIN
            RAISERROR('El estudiante ya está registrado en una mesa de identificación para esta elección.', 16, 1);
        END;


        -- 4) Registrar estudiante en la mesa
        INSERT INTO mesa_identificacion_estudiante (mesa_identificacion_id, documento_estudiante)
        VALUES (@MesaIdentificacionId, @DocumentoEstudiante);


        -- 5) Generación del token seguro (GUID + timestamp + datos variables)
        DECLARE @GUID UNIQUEIDENTIFIER = NEWID();

        DECLARE @TextoToken NVARCHAR(200) =
            CONCAT(
                @DocumentoEstudiante, '-',
                @MesaIdentificacionId, '-',
                CONVERT(VARCHAR(30), SYSDATETIME(), 126), '-',
                @GUID
            );

        INSERT INTO token_votante (codigo_token, mesa_identificacion_id, usado)
        VALUES (HASHBYTES('SHA2_256', @TextoToken), @MesaIdentificacionId, 0);


        -- 6) Todo correcto → confirmar transacción
        COMMIT TRAN;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        DECLARE @MensajeError NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@MensajeError, 16, 1);
    END CATCH
END;
GO


---------------------------------------------------------------------------
			      -- 2. Datos de prueba --
---------------------------------------------------------------------------
INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (37000001, 'Brenda', 'Ayala', 'brenda.ayala@unne.edu.ar'),
       (36000002, 'Marcelo', 'Suarez', 'marcelo.suarez@gmail.com');

INSERT INTO carrera_estudiante (carrera_id, documento_estudiante, año_ingreso, estado_id)
VALUES (1, 37000001, '2023-03-01', 1),   -- Regular
       (1, 36000002, '2023-03-01', 2);   -- Egresado/NO-Regular



---------------------------------------------------------------------------
		  -- 3. Prueba de registro en mesa de identificacion --
---------------------------------------------------------------------------
-- Caso exitoso
EXEC sp_RegistrarEnMesaIdentificacion
    @DocumentoEstudiante = 37000001,
    @MesaIdentificacionId = 1;

-- Caso que debe fallar (no es Regular)
EXEC sp_RegistrarEnMesaIdentificacion
    @DocumentoEstudiante = 36000002,
    @MesaIdentificacionId = 1;

-- Caso que debe fallar (el estudiante ya se identifico en una mesa)
EXEC sp_RegistrarEnMesaIdentificacion 37000001, 2;

---------------------------------------------------------------------------
		                -- 4. Verificaciones --
---------------------------------------------------------------------------
SELECT * FROM mesa_identificacion_estudiante WHERE documento_estudiante IN (37000001, 36000002);
SELECT * FROM token_votante ORDER BY token_id DESC;


---------------------------------------------------------------------------
		                -- 5. Conclusiones --
---------------------------------------------------------------------------
--  En esta etapa de mesa de identificación se implementó un procedimiento almacenado que utiliza una transacción para 
--  asegurar la atomicidad del proceso.
--  Este procedimiento:
--      * valida que el estudiante exista y que tenga estado Regular dentro de su carrera
--      * se verifica que no haya sido registrado previamente en otra mesa para la misma elección, garantizando la 
--        integridad del padrón. 
--  Caso de error:
--      Si cualquiera de estas condiciones falla, la transacción se cancela mediante ROLLBACK, evitando cambios parciales
--  o inconsistentes en las tablas mesa_identificacion_estudiante y token_votante.
--  Caso exitoso:
--      Cuando las validaciones son correctas, el sistema registra al estudiante en la mesa y genera un token seguro  
--  mediante SHA-256, construido a partir de información variable como el documento, la mesa, la fecha/hora y un GUID aleatorio.

--  En las pruebas realizadas, solo el estudiante Regular fue registrado exitosamente; el estudiante con estado No Regular 
--  fue rechazado y no produjo inserciones, asi como el estudiante que se intentò identificar en otra mesa cuando ya 
--  esatba registrado, demostrando el funcionamiento correcto de la transacción.