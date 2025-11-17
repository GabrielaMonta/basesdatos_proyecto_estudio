--CREATE DATABASE proyecto_elecciones;
--GO

USE proyecto_elecciones
GO

-- ============================================================================
-- PROYECTO: Sistema de Voto Electrónico Estudiantil
-- BASE DE DATOS: proyecto_elecciones
-- TEMA: Procedimientos y Funciones Almacenadas 
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PROCEDIMIENTO 1: Insertar Estudiante (INSERT)
-- Permite que un estudiante emita su voto usando su token
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'sp_InsertarEstudiante')
BEGIN
    DROP PROCEDURE sp_InsertarEstudiante
END
go
CREATE PROCEDURE sp_InsertarEstudiante
    @documento_estudiante INT,
    @nombre VARCHAR(50),
    @apellido VARCHAR(50),
    @email VARCHAR(80)
AS
BEGIN
    BEGIN TRY
        -- VALIDACIÓN 1: Verificar que el documento no esté duplicado
        IF EXISTS (SELECT 1 FROM estudiante WHERE documento_estudiante = @documento_estudiante)
        BEGIN
            RAISERROR('Ya existe un estudiante con ese número de documento', 16, 1)
            RETURN
        END
        
        -- VALIDACIÓN 2: Verificar que el email no esté en uso
        IF EXISTS (SELECT 1 FROM estudiante WHERE email = @email)
        BEGIN
            RAISERROR('El email ya está registrado en el sistema', 16, 1)
            RETURN
        END
        
        -- VALIDACIÓN 3: Verificar que el documento sea positivo
        IF @documento_estudiante <= 0
        BEGIN
            RAISERROR('El documento debe ser un número positivo', 16, 1)
            RETURN
        END
        
        -- VALIDACIÓN 4: Verificar que nombre y apellido no estén vacíos
        IF LTRIM(RTRIM(@nombre)) = '' OR LTRIM(RTRIM(@apellido)) = ''
        BEGIN
            RAISERROR('El nombre y apellido son obligatorios', 16, 1)
            RETURN
        END
        
        -- VALIDACIÓN 5: Validar formato de email básico
        IF @email NOT LIKE '%@%.%'
        BEGIN
            RAISERROR('El formato del email no es válido', 16, 1)
            RETURN
        END
        
        -- Insertar el estudiante
        INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
        VALUES (@documento_estudiante, @nombre, @apellido, @email)
        
        PRINT '✅ Estudiante insertado exitosamente'
        PRINT 'Documento: ' + CAST(@documento_estudiante AS VARCHAR)
        PRINT 'Nombre: ' + @nombre + ' ' + @apellido
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT '✅ Procedimiento sp_InsertarEstudiante creado';
GO
-- ====================================================
-- 🔹 INSERCIÓN  DE ESTUDIANTES UTILIZANDO PROCEDIMINETOS
-- ====================================================

-- NUEVOS ESTUDIANTES (LOTE 1)
PRINT '--- INSERTAR NUEVOS ESTUDIANTES (LOTE 1) ---'

EXEC sp_InsertarEstudiante 41789012, 'Brenda', 'Villalba', 'brenda.villalba@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 41890123, 'Matías', 'Ortega', 'matias.ortega@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 41901234, 'Rocío', 'Salinas', 'rocio.salinas@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 42012345, 'Diego', 'Ferreyra', 'diego.ferreyra@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 42123456, 'Ludmila', 'Gutiérrez', 'ludmila.gutierrez@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 42234567, 'Bautista', 'Molina', 'bautista.molina@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 42345678, 'Ariana', 'Vázquez', 'ariana.vazquez@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 42456789, 'Jonás', 'Torres', 'jonas.torres@estudiante.unne.edu.ar';

GO

-- Verificar resultados
SELECT * FROM estudiante;
GO


-- Candidatos
PRINT '--- INSERTAR CANDIDATOS (LOTE 2) ---'

EXEC sp_InsertarEstudiante 36567890, 'Sabrina', 'López', 'sabrina.lopez@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 36678901, 'Rubén', 'García', 'ruben.garcia@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 36789012, 'Lucía', 'Campos', 'lucia.campos@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 36890123, 'Axel', 'Rivas', 'axel.rivas@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 36901234, 'Valentín', 'Frías', 'valentin.frias@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 37012345, 'Martina', 'Zárate', 'martina.zarate@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 37123456, 'Tomás', 'Ledesma', 'tomas.ledesma@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 37234567, 'Camila', 'Correa', 'camila.correa@estudiante.unne.edu.ar';

GO

-- ----------------------------------------------------------------------------
-- TABLA: Estudiante LOTE 3 DIRECTO
-- ----------------------------------------------------------------------------
INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40123456, 'Sofía', 'García', 'sofia_garcia@unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40234567, 'Mateo', 'Fernández', 'matefer@hotmail.com');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40345678, 'Valentina', 'López', 'valentinalo@hotmail.com');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40456789, 'Santiago', 'Martínez', 'santiago.martinez@hotmail.com');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40901234, 'Agustina', 'Mendoza', 'agustina.mendoza@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (41012345, 'Franco', 'Benítez', 'franco.benitez@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (41123456, 'Jazmín', 'Romero', 'jazmin.romero@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (41234567, 'Tomás', 'Herrera', 'tomas.herrera@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (41345678, 'Carolina', 'Acosta', 'carolina.acosta@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (41456789, 'Federico', 'Gómez', 'federico.gomez@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (41567890, 'Milagros', 'Luna', 'milagros.luna@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (41678901, 'Ezequiel', 'Suárez', 'ezequiel.suarez@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40567890, 'Camila', 'Vega', 'camila.vega@hotmail.com');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40678901, 'Bruno', 'Silva', 'brunosilva@outlook.com');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40789012, 'Sabrina', 'Cruz', 'sabri.cruz@unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40890123, 'Lucas', 'Ortiz', 'ortiz.lucas@gmail.com');

-- Verificar resultados
SELECT * FROM estudiante;
GO


-- Candidatos
-- LOTE 4 DE CANDIDATOS
INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35123456, 'Juan', 'Perez', 'juan.perez@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35234567, 'María', 'González', 'maria.gonzalez@gmail.com');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35345678, 'Carlos', 'López', 'carlos.lopez@unne.com');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35456789, 'Ana', 'Martínez', 'ana.martinez@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35789012, 'Federico', 'Ramos', 'federico.ramos@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35890123, 'Agustina', 'Pereyra', 'agustina.pereyra@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35901234, 'Luciano', 'Navarro', 'luciano.navarro@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (36012345, 'Camila', 'Sosa', 'camila.sosa@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (36123456, 'Tomás', 'Romero', 'tomas.romero@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (36234567, 'Valeria', 'Herrera', 'valeria.herrera@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (36345678, 'Nicolás', 'Medina', 'nicolas.medina@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (36456789, 'Julieta', 'Figueroa', 'julieta.figueroa@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35567890, 'Pedro', 'Fernández', 'pedrofernandez@gmail.com');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35678901, 'Laura', 'Rodríguez', 'laura.rodriguez@gmail.com');




-- ============================================================================
-- PROCEDIMIENTO 2: MODIFICAR ESTUDIANTE (UPDATE)
-- Permite actualizar los datos de un estudiante
-- ============================================================================

-- Eliminar procedimiento si existe
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'sp_ModificarEstudiante')
BEGIN
    DROP PROCEDURE sp_ModificarEstudiante
END
GO

CREATE PROCEDURE sp_ModificarEstudiante
    @documento_estudiante INT,
    @nombre VARCHAR(50),
    @apellido VARCHAR(50),
    @email VARCHAR(80)
AS
BEGIN
    BEGIN TRY
        -- VALIDACION 1: Verificar que el estudiante existe
        IF NOT EXISTS (SELECT 1 FROM estudiante WHERE documento_estudiante = @documento_estudiante)
        BEGIN
            RAISERROR('El estudiante no existe en el sistema', 16, 1)
            RETURN
        END
        
        -- VALIDACION 2: Verificar que el email no este en uso por otro estudiante
        IF EXISTS (SELECT 1 FROM estudiante 
                   WHERE email = @email 
                   AND documento_estudiante <> @documento_estudiante)
        BEGIN
            RAISERROR('El email ya esta registrado por otro estudiante', 16, 1)
            RETURN
        END
        
        -- VALIDACION 3: Verificar que nombre y apellido no esten vacios
        IF LTRIM(RTRIM(@nombre)) = '' OR LTRIM(RTRIM(@apellido)) = ''
        BEGIN
            RAISERROR('El nombre y apellido son obligatorios', 16, 1)
            RETURN
        END
        
        -- VALIDACION 4: Validar formato de email basico
        IF @email NOT LIKE '%@%.%'
        BEGIN
            RAISERROR('El formato del email no es valido', 16, 1)
            RETURN
        END
        
        -- Actualizar datos del estudiante
        UPDATE estudiante
        SET nombre = @nombre,
            apellido = @apellido,
            email = @email
        WHERE documento_estudiante = @documento_estudiante
        
        PRINT 'Estudiante modificado exitosamente'
        PRINT 'Documento: ' + CAST(@documento_estudiante AS VARCHAR)
        PRINT 'Nuevo nombre: ' + @nombre + ' ' + @apellido
        PRINT 'Nuevo email: ' + @email
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

PRINT 'Procedimiento sp_ModificarEstudiante creado correctamente';
GO

-- ============================================================================
-- EJECUCION: MODIFICAR ESTUDIANTES 
-- ============================================================================

PRINT '';
PRINT '============================================';
PRINT '  MODIFICANDO ESTUDIANTES EXISTENTES';
PRINT '============================================';
PRINT '';

-- Ver datos antes de modificar
PRINT '--- DATOS ANTES DE MODIFICAR ---';
SELECT documento_estudiante, nombre, apellido, email
FROM estudiante
WHERE documento_estudiante IN (41789012, 41890123, 40123456, 40234567);
GO

-- Modificar estudiante 1: Brenda Villalba
PRINT '';
PRINT '--- Modificando estudiante 41789012 ---';
EXEC sp_ModificarEstudiante 
    @documento_estudiante = 41789012,
    @nombre = 'Brenda Soledad',
    @apellido = 'Villalba Martinez',
    @email = 'brenda.villalba.actualizado@estudiante.unne.edu.ar';
GO

-- Modificar estudiante 2: Matias Ortega
PRINT '';
PRINT '--- Modificando estudiante 41890123 ---';
EXEC sp_ModificarEstudiante 
    @documento_estudiante = 41890123,
    @nombre = 'Matias Ezequiel',
    @apellido = 'Ortega Ramirez',
    @email = 'matias.ortega.actualizado@estudiante.unne.edu.ar';
GO

-- Modificar estudiante 3: Sofia Garcia
PRINT '';
PRINT '--- Modificando estudiante 40123456 ---';
EXEC sp_ModificarEstudiante 
    @documento_estudiante = 40123456,
    @nombre = 'Sofia Valentina',
    @apellido = 'Garcia Lopez',
    @email = 'sofia.garcia.actualizado@estudiante.unne.edu.ar';
GO

-- Modificar estudiante 4: Mateo Fernandez
PRINT '';
PRINT '--- Modificando estudiante 40234567 ---';
EXEC sp_ModificarEstudiante 
    @documento_estudiante = 40234567,
    @nombre = 'Mateo Sebastian',
    @apellido = 'Fernandez Gomez',
    @email = 'mateo.fernandez.actualizado@estudiante.unne.edu.ar';
GO

-- Ver datos despues de modificar
PRINT '';
PRINT '--- DATOS DESPUES DE MODIFICAR ---';
SELECT documento_estudiante, nombre, apellido, email
FROM estudiante
WHERE documento_estudiante IN (41789012, 41890123, 40123456, 40234567);
GO

-- ============================================================================
-- PRUEBAS DE VALIDACION
-- ============================================================================

PRINT '';
PRINT '============================================';
PRINT '  PRUEBAS DE VALIDACION';
PRINT '============================================';
PRINT '';

-- Prueba 1: Intentar modificar estudiante inexistente
PRINT '--- PRUEBA 1: Estudiante inexistente ---';
EXEC sp_ModificarEstudiante 
    @documento_estudiante = 99999999,
    @nombre = 'Test',
    @apellido = 'Usuario',
    @email = 'test@test.com';
GO

-- Prueba 2: Intentar usar email duplicado
PRINT '';
PRINT '--- PRUEBA 2: Email duplicado ---';
EXEC sp_ModificarEstudiante 
    @documento_estudiante = 41789012,
    @nombre = 'Brenda',
    @apellido = 'Villalba',
    @email = 'matias.ortega.actualizado@estudiante.unne.edu.ar';
GO

-- Prueba 3: Email con formato invalido
PRINT '';
PRINT '--- PRUEBA 3: Email invalido ---';
EXEC sp_ModificarEstudiante 
    @documento_estudiante = 41789012,
    @nombre = 'Brenda',
    @apellido = 'Villalba',
    @email = 'email_invalido';
GO

PRINT '';
PRINT '============================================';
PRINT '  FIN DE PRUEBAS DE MODIFICACION';
PRINT '============================================';
GO


-- ====================================================
-- 🔹 DELETE DIRECTO DE ESTUDIANTES 
-- ====================================================

PRINT '--- ELIMINAR ESTUDIANTES (DELETE DIRECTO) ---'

-- Eliminar estudiante por documento
DELETE FROM estudiante 
WHERE documento_estudiante = 43111222;
PRINT '✅ Estudiante 43111222 eliminado'

DELETE FROM estudiante 
WHERE documento_estudiante = 43222333;
PRINT '✅ Estudiante 43222333 eliminado'

DELETE FROM estudiante 
WHERE documento_estudiante = 43333444;
PRINT '✅ Estudiante 43333444 eliminado'

DELETE FROM estudiante 
WHERE documento_estudiante = 43444555;
PRINT '✅ Estudiante 43444555 eliminado'

-- Verificar resultados
SELECT * FROM estudiante 
WHERE documento_estudiante IN (43111222, 43222333, 43333444, 43444555);
GO

-- ====================================================
-- 🔹 DELETE USANDO PROCEDIMIENTOS ALMACENADOS
-- ====================================================

-- ----------------------------------------------------------------------------
-- PROCEDIMIENTO 3: Eliminar Estudiante (DELETE)
-- Permite eliminar un estudiante del sistema con validaciones
-- ----------------------------------------------------------------------------

IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'sp_EliminarEstudiante')
BEGIN
    DROP PROCEDURE sp_EliminarEstudiante
END
GO

CREATE PROCEDURE sp_EliminarEstudiante
    @documento_estudiante INT
AS
BEGIN
    BEGIN TRY
        
        ---------------------------------------------------------
        -- 1. Verificar que exista
        ---------------------------------------------------------
        IF NOT EXISTS (
            SELECT 1 
            FROM estudiante 
            WHERE documento_estudiante = @documento_estudiante
        )
        BEGIN
            RAISERROR('El estudiante no existe en el sistema.', 16, 1)
            RETURN
        END


        ---------------------------------------------------------
        -- 2. Verificar si es candidato (dos tablas)
        ---------------------------------------------------------
        IF EXISTS (
            SELECT 1 
            FROM cargo_banca_estudiante
            WHERE documento_estudiante = @documento_estudiante
        )
        BEGIN
            RAISERROR('No se puede eliminar: el estudiante es candidato.', 16, 1)
            RETURN
        END

        IF EXISTS (
            SELECT 1
            FROM lista_cargos
            WHERE documento_estudiante = @documento_estudiante
        )
        BEGIN
            RAISERROR('No se puede eliminar: el estudiante está registrado en una lista.', 16, 1)
            RETURN
        END


        ---------------------------------------------------------
        -- 3. Verificar si ya votó
        --
        -- estudiante → mesa_identificacion_estudiante → mesa_identificacion
        -- mesa_identificacion → token_votante → voto
        ---------------------------------------------------------
        IF EXISTS (
            SELECT 1
            FROM mesa_identificacion_estudiante mie
            INNER JOIN token_votante tv
                ON tv.mesa_identificacion_id = mie.mesa_identificacion_id
            INNER JOIN voto v
                ON v.token_id = tv.token_id
            WHERE mie.documento_estudiante = @documento_estudiante
        )
        BEGIN
            RAISERROR('No se puede eliminar: el estudiante ya emitió su voto.', 16, 1)
            RETURN
        END


        ---------------------------------------------------------
        -- Guardar datos (solo para mostrar)
        ---------------------------------------------------------
        DECLARE @nombre VARCHAR(50), @apellido VARCHAR(50)
        SELECT @nombre = nombre, @apellido = apellido
        FROM estudiante
        WHERE documento_estudiante = @documento_estudiante


        ---------------------------------------------------------
        -- 4. Eliminar al estudiante
        ---------------------------------------------------------
        DELETE FROM estudiante
        WHERE documento_estudiante = @documento_estudiante


        PRINT '✅ Estudiante eliminado exitosamente.'
        PRINT 'Documento: ' + CAST(@documento_estudiante AS VARCHAR)
        PRINT 'Nombre: ' + @nombre + ' ' + @apellido

    END TRY
    BEGIN CATCH
        DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@msg, 16, 1)
    END CATCH
END
GO


-- ====================================================
-- 🔹 EJECUCIÓN DE DELETE CON PROCEDIMIENTOS
-- ====================================================

PRINT '--- ELIMINAR ESTUDIANTES USANDO PROCEDIMIENTO ---';

-- Eliminar estudiantes existentes
EXEC sp_EliminarEstudiante 43555666;
EXEC sp_EliminarEstudiante 43666777;
EXEC sp_EliminarEstudiante 43777888;
EXEC sp_EliminarEstudiante 43888999;

-- Verificar que fueron eliminados
SELECT * FROM estudiante
WHERE documento_estudiante IN (43555666, 43666777, 43777888, 43888999);
GO


-- ====================================================
-- 🔹 PRUEBAS DE VALIDACIÓN
-- ====================================================

PRINT '--- PRUEBAS DE VALIDACIÓN DEL PROCEDIMIENTO ---';

-- Intentar eliminar un estudiante que no existe
PRINT 'Intento eliminar estudiante inexistente:';
EXEC sp_EliminarEstudiante 99999999;

-- Intentar eliminar un estudiante que es candidato
PRINT 'Intento eliminar estudiante que es candidato:';
EXEC sp_EliminarEstudiante 35789012;

GO

-- Verificar que ninguno de los anteriores se eliminó
SELECT * FROM estudiante
WHERE documento_estudiante IN (99999999, 35789012);
GO


-- ============================================================================
-- FUNCIONES ALMACENADAS - TABLA ESTUDIANTE
-- ============================================================================

-- ============================================================================
-- FUNCION 1: Obtener nombre completo del estudiante
-- Retorna el nombre completo concatenado
-- ============================================================================

-- Eliminar funcion si existe
IF EXISTS (SELECT 1 FROM sys.objects WHERE type IN ('FN', 'IF', 'TF') AND name = 'fn_ObtenerNombreCompleto')
BEGIN
    DROP FUNCTION fn_ObtenerNombreCompleto
END
GO

CREATE FUNCTION fn_ObtenerNombreCompleto(@documento_estudiante INT)
RETURNS VARCHAR(120)
AS
BEGIN
    DECLARE @nombreCompleto VARCHAR(120)
    
    SELECT @nombreCompleto = nombre + ' ' + apellido
    FROM estudiante
    WHERE documento_estudiante = @documento_estudiante
    
    RETURN ISNULL(@nombreCompleto, 'Estudiante no encontrado')
END
GO

PRINT 'Funcion fn_ObtenerNombreCompleto creada correctamente';
GO

-- ============================================================================
-- FUNCION 2: Verificar si estudiante existe
-- Retorna 1 si existe, 0 si no existe
-- ============================================================================

-- Eliminar funcion si existe
IF EXISTS (SELECT 1 FROM sys.objects WHERE type IN ('FN', 'IF', 'TF') AND name = 'fn_ExisteEstudiante')
BEGIN
    DROP FUNCTION fn_ExisteEstudiante
END
GO

CREATE FUNCTION fn_ExisteEstudiante(@documento_estudiante INT)
RETURNS BIT
AS
BEGIN
    DECLARE @existe BIT
    SET @existe = 0
    
    IF EXISTS (SELECT 1 FROM estudiante WHERE documento_estudiante = @documento_estudiante)
    BEGIN
        SET @existe = 1
    END
    
    RETURN @existe
END
GO

PRINT 'Funcion fn_ExisteEstudiante creada correctamente';
GO

-- ============================================================================
-- FUNCION 3: Funcion tabla - Listar estudiantes por dominio de email
-- Retorna una tabla con estudiantes que tienen un dominio especifico
-- ============================================================================

-- Eliminar funcion si existe
IF EXISTS (SELECT 1 FROM sys.objects WHERE type IN ('FN', 'IF', 'TF') AND name = 'fn_ListarEstudiantesPorDominio')
BEGIN
    DROP FUNCTION fn_ListarEstudiantesPorDominio
END
GO

CREATE FUNCTION fn_ListarEstudiantesPorDominio(@dominio VARCHAR(80))
RETURNS TABLE
AS
RETURN
(
    SELECT 
        documento_estudiante,
        nombre,
        apellido,
        email
    FROM estudiante
    WHERE email LIKE '%@' + @dominio
)
GO

PRINT 'Funcion fn_ListarEstudiantesPorDominio creada correctamente';
GO

-- ============================================================================
-- PRUEBAS DE FUNCIONES ALMACENADAS
-- ============================================================================

PRINT '';
PRINT '============================================';
PRINT '  PRUEBAS DE FUNCIONES ALMACENADAS';
PRINT '============================================';
PRINT '';
GO

-- ============================================================================
-- PRUEBA 1: Obtener nombre completo
-- ============================================================================
PRINT '--- PRUEBA 1: Nombre Completo ---';

-- Caso 1: Estudiante existente
SELECT 
    40901234 AS Documento,
    dbo.fn_ObtenerNombreCompleto(40901234) AS NombreCompleto;

-- Caso 2: Estudiante inexistente
SELECT 
    99999999 AS Documento,
    dbo.fn_ObtenerNombreCompleto(99999999) AS NombreCompleto;

PRINT '';
GO

-- ============================================================================
-- PRUEBA 2: Verificar existencia
-- ============================================================================
PRINT '--- PRUEBA 2: Verificar Existencia ---';

SELECT 
    40901234 AS Documento,
    dbo.fn_ExisteEstudiante(40901234) AS Existe,
    CASE 
        WHEN dbo.fn_ExisteEstudiante(40901234) = 1 THEN 'SI'
        ELSE 'NO'
    END AS Estado
UNION ALL
SELECT 
    99999999 AS Documento,
    dbo.fn_ExisteEstudiante(99999999) AS Existe,
    CASE 
        WHEN dbo.fn_ExisteEstudiante(99999999) = 1 THEN 'SI'
        ELSE 'NO'
    END AS Estado;

PRINT '';
GO

-- ============================================================================
-- PRUEBA 3: Listar por dominio (funcion tabla)
-- ============================================================================

PRINT '--- PRUEBA 3: Estudiantes del dominio UNNE ---'
SELECT * FROM dbo.fn_ListarEstudiantesPorDominio('estudiante.unne.edu.ar')
GO
PRINT ''
PRINT '✅ Todas las pruebas de funciones completadas'
GO

-- ============================================================================
-- PRUEBA 4: Listar por otros dominios
-- ============================================================================
PRINT '--- PRUEBA 4: Estudiantes de otros dominios ---';

-- Gmail
PRINT 'Estudiantes con Gmail:';
SELECT * FROM dbo.fn_ListarEstudiantesPorDominio('gmail.com');

-- Hotmail
PRINT '';
PRINT 'Estudiantes con Hotmail:';
SELECT * FROM dbo.fn_ListarEstudiantesPorDominio('hotmail.com');

-- Outlook
PRINT '';
PRINT 'Estudiantes con Outlook:';
SELECT * FROM dbo.fn_ListarEstudiantesPorDominio('outlook.com');

PRINT '';
GO

-- ============================================================================
-- PRUEBA 5: Uso combinado de funciones
-- ============================================================================
PRINT '--- PRUEBA 5: Uso Combinado de Funciones ---';

SELECT 
    e.documento_estudiante AS Documento,
    dbo.fn_ObtenerNombreCompleto(e.documento_estudiante) AS NombreCompleto,
    dbo.fn_ExisteEstudiante(e.documento_estudiante) AS Existe,
    e.email AS Email
FROM estudiante e
WHERE e.documento_estudiante IN (40901234, 41789012, 40123456)
ORDER BY e.apellido;

PRINT '';
GO

PRINT '============================================';
PRINT '  TODAS LAS PRUEBAS COMPLETADAS';
PRINT '============================================';
GO




-- ============================================================================
-- PRUEBA DE EFICIENCIA: DIRECTO vs PROCEDIMIENTOS ALMACENADOS
-- ============================================================================

PRINT '============================================';
PRINT '  INICIO DE PRUEBAS DE EFICIENCIA';
PRINT '============================================';
PRINT '';
GO

-- ============================================================================
-- PRUEBA 1A: INSERT DIRECTO - 100 registros
-- ============================================================================
PRINT '--- PRUEBA 1A: INSERT DIRECTO (100 registros) ---';

DECLARE @inicio DATETIME2;
DECLARE @fin DATETIME2;
DECLARE @i INT;

SET @inicio = SYSDATETIME();
SET @i = 1;

WHILE @i <= 100
BEGIN
    INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
    VALUES (
        50000000 + @i,
        'Nombre' + CAST(@i AS VARCHAR(10)),
        'Apellido' + CAST(@i AS VARCHAR(10)),
        'email' + CAST(@i AS VARCHAR(10)) + '@test.com'
    );
    SET @i = @i + 1;
END

SET @fin = SYSDATETIME();
PRINT 'Tiempo INSERT DIRECTO: ' + CAST(DATEDIFF(MILLISECOND, @inicio, @fin) AS VARCHAR(20)) + ' ms';
PRINT '';
GO

-- ============================================================================
-- PRUEBA 1B: INSERT CON PROCEDIMIENTO - 100 registros
-- ============================================================================
PRINT '--- PRUEBA 1B: INSERT CON PROCEDIMIENTO (100 registros) ---';

DECLARE @inicio DATETIME2;
DECLARE @fin DATETIME2;
DECLARE @i INT;
DECLARE @doc INT;
DECLARE @nom VARCHAR(50);
DECLARE @ape VARCHAR(50);
DECLARE @mail VARCHAR(80);

SET @inicio = SYSDATETIME();
SET @i = 1;

WHILE @i <= 100
BEGIN
    SET @doc = 60000000 + @i;
    SET @nom = 'Nom' + CAST(@i AS VARCHAR(10));
    SET @ape = 'Ape' + CAST(@i AS VARCHAR(10));
    SET @mail = 'correo' + CAST(@i AS VARCHAR(10)) + '@test.com';
    
    EXEC sp_InsertarEstudiante @doc, @nom, @ape, @mail;
    
    SET @i = @i + 1;
END

SET @fin = SYSDATETIME();
PRINT 'Tiempo INSERT CON SP: ' + CAST(DATEDIFF(MILLISECOND, @inicio, @fin) AS VARCHAR(20)) + ' ms';
PRINT '';
GO

-- ============================================================================
-- PRUEBA 2A: UPDATE DIRECTO - 50 registros
-- ============================================================================
PRINT '--- PRUEBA 2A: UPDATE DIRECTO (50 registros) ---';

DECLARE @inicio DATETIME2;
DECLARE @fin DATETIME2;
DECLARE @i INT;

SET @inicio = SYSDATETIME();
SET @i = 1;

WHILE @i <= 50
BEGIN
    UPDATE estudiante
    SET nombre = 'NuevoNombre' + CAST(@i AS VARCHAR(10))
    WHERE documento_estudiante = 50000000 + @i;
    
    SET @i = @i + 1;
END

SET @fin = SYSDATETIME();
PRINT 'Tiempo UPDATE DIRECTO: ' + CAST(DATEDIFF(MILLISECOND, @inicio, @fin) AS VARCHAR(20)) + ' ms';
PRINT '';
GO

-- ============================================================================
-- PRUEBA 2B: UPDATE CON PROCEDIMIENTO - 50 registros
-- ============================================================================
PRINT '--- PRUEBA 2B: UPDATE CON PROCEDIMIENTO (50 registros) ---';

DECLARE @inicio DATETIME2;
DECLARE @fin DATETIME2;
DECLARE @i INT;
DECLARE @doc INT;
DECLARE @nom VARCHAR(50);
DECLARE @ape VARCHAR(50);
DECLARE @mail VARCHAR(80);

SET @inicio = SYSDATETIME();
SET @i = 1;

WHILE @i <= 50
BEGIN
    SET @doc = 60000000 + @i;
    SET @nom = 'NuevoNom' + CAST(@i AS VARCHAR(10));
    SET @ape = 'Ape' + CAST(@i AS VARCHAR(10));
    SET @mail = 'correo' + CAST(@i AS VARCHAR(10)) + '@test.com';
    
    EXEC sp_ModificarEstudiante @doc, @nom, @ape, @mail;
    
    SET @i = @i + 1;
END

SET @fin = SYSDATETIME();
PRINT 'Tiempo UPDATE CON SP: ' + CAST(DATEDIFF(MILLISECOND, @inicio, @fin) AS VARCHAR(20)) + ' ms';
PRINT '';
GO

-- ============================================================================
-- PRUEBA 3A: DELETE DIRECTO - 50 registros
-- ============================================================================
PRINT '--- PRUEBA 3A: DELETE DIRECTO (50 registros) ---';

DECLARE @inicio DATETIME2;
DECLARE @fin DATETIME2;
DECLARE @i INT;

SET @inicio = SYSDATETIME();
SET @i = 1;

WHILE @i <= 50
BEGIN
    DELETE FROM estudiante
    WHERE documento_estudiante = 50000000 + @i;
    
    SET @i = @i + 1;
END

SET @fin = SYSDATETIME();
PRINT 'Tiempo DELETE DIRECTO: ' + CAST(DATEDIFF(MILLISECOND, @inicio, @fin) AS VARCHAR(20)) + ' ms';
PRINT '';
GO

-- ============================================================================
-- PRUEBA 3B: DELETE CON PROCEDIMIENTO - 50 registros
-- ============================================================================
PRINT '--- PRUEBA 3B: DELETE CON PROCEDIMIENTO (50 registros) ---';

DECLARE @inicio DATETIME2;
DECLARE @fin DATETIME2;
DECLARE @i INT;
DECLARE @doc INT;

SET @inicio = SYSDATETIME();
SET @i = 1;

WHILE @i <= 50
BEGIN
    SET @doc = 60000000 + @i;
    EXEC sp_EliminarEstudiante @doc;
    SET @i = @i + 1;
END

SET @fin = SYSDATETIME();
PRINT 'Tiempo DELETE CON SP: ' + CAST(DATEDIFF(MILLISECOND, @inicio, @fin) AS VARCHAR(20)) + ' ms';
PRINT '';
GO

-- ============================================================================
-- LIMPIEZA DE DATOS DE PRUEBA
-- ============================================================================
PRINT '============================================';
PRINT '  LIMPIEZA DE DATOS DE PRUEBA';
PRINT '============================================';

DELETE FROM estudiante 
WHERE documento_estudiante >= 50000000 
  AND documento_estudiante < 70000100;

PRINT 'Registros de prueba eliminados';
PRINT '';


-- ============================================================================
-- CONCLUSIONES DE LA PRUEBA DE EFICIENCIA
-- ============================================================================
PRINT '============================================';
PRINT '  CONCLUSIONES';
PRINT '============================================';
PRINT '';
PRINT '1. OPERACIONES DIRECTAS (INSERT/UPDATE/DELETE):';
PRINT '   - Mayor velocidad de ejecucion';
PRINT '   - Menor overhead de procesamiento';
PRINT '   - Ideal para operaciones masivas sin validaciones complejas';
PRINT '';
PRINT '2. PROCEDIMIENTOS ALMACENADOS:';
PRINT '   - Ligeramente mas lentos debido a validaciones';
PRINT '   - Garantizan integridad y consistencia de datos';
PRINT '   - Centralizan la logica de negocio';
PRINT '   - Facilitan el mantenimiento y reutilizacion';
PRINT '   - Mejoran la seguridad mediante encapsulamiento';
PRINT '';
PRINT '';
PRINT '============================================';
PRINT '  FIN DE PRUEBAS DE EFICIENCIA';
PRINT '============================================';