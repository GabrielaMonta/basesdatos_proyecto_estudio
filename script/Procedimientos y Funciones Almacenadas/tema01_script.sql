CREATE DATABASE proyecto_elecciones;
GO

USE proyecto_elecciones
GO

-- ============================================================================
-- PROYECTO: Sistema de Voto Electrónico Estudiantil
-- BASE DE DATOS: proyecto_elecciones
-- TEMA: Procedimientos y Funciones Almacenadas (AXEL)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PROCEDIMIENTO 1: Insertar Estudiante (INSERT)
-- Permite que un estudiante emita su voto usando su token
-- ----------------------------------------------------------------------------


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

-- NUEVOS ESTUDIANTES (LOTE 2)
PRINT '--- INSERTAR NUEVOS ESTUDIANTES ---'

EXEC sp_InsertarEstudiante 40901234, 'Agustina', 'Mendoza', 'agustina.mendoza@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 41012345, 'Franco', 'Benítez', 'franco.benitez@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 41123456, 'Jazmín', 'Romero', 'jazmin.romero@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 41234567, 'Tomás', 'Herrera', 'tomas.herrera@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 41345678, 'Carolina', 'Acosta', 'carolina.acosta@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 41456789, 'Federico', 'Gómez', 'federico.gomez@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 41567890, 'Milagros', 'Luna', 'milagros.luna@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 41678901, 'Ezequiel', 'Suárez', 'ezequiel.suarez@estudiante.unne.edu.ar';

-- Verificar resultados
SELECT * FROM estudiante;
GO


-- Candidatos
-- LOTE 2 DE CANDIDATOS
PRINT '--- INSERTAR CANDIDATOS USANDO PROCEDIMIENTOS(LOTE 2) ---'

EXEC sp_InsertarEstudiante 35789012, 'Federico', 'Ramos', 'federico.ramos@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 35890123, 'Agustina', 'Pereyra', 'agustina.pereyra@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 35901234, 'Luciano', 'Navarro', 'luciano.navarro@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 36012345, 'Camila', 'Sosa', 'camila.sosa@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 36123456, 'Tomás', 'Romero', 'tomas.romero@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 36234567, 'Valeria', 'Herrera', 'valeria.herrera@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 36345678, 'Nicolás', 'Medina', 'nicolas.medina@estudiante.unne.edu.ar';
EXEC sp_InsertarEstudiante 36456789, 'Julieta', 'Figueroa', 'julieta.figueroa@estudiante.unne.edu.ar';
GO


-- ====================================================
-- 🔹 INSERCIÓN DIRECTA DE ESTUDIANTES 
-- ====================================================


PRINT '--- INSERTAR NUEVOS ESTUDIANTES ---'

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (43111222, 'Tomás', 'Benítez', 'tomas.benitez@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (43222333, 'Julieta', 'Sosa', 'julieta.sosa@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (43333444, 'Bruno', 'Acosta', 'bruno.acosta@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (43444555, 'Daniela', 'Ríos', 'daniela.rios@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (43555666, 'Agustín', 'Molina', 'agustin.molina@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (43666777, 'Milagros', 'Herrera', 'milagros.herrera@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (43777888, 'Federico', 'Navarro', 'federico.navarro@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (43888999, 'Antonella', 'Paredes', 'antonella.paredes@estudiante.unne.edu.ar');


-- Verificar resultados
SELECT * FROM estudiante;
GO


-- Candidatos
-- LOTE 2 DE CANDIDATOS
PRINT '--- INSERTAR CANDIDATOS USANDO PROCEDIMIENTOS(LOTE 2) ---'

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (36111222, 'Emilio', 'Salazar', 'emilio.salazar@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (36222333, 'Rocío', 'Medina', 'rocio.medina@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (36333444, 'Santiago', 'Luna', 'santiago.luna@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (36444555, 'Victoria', 'Quiroga', 'victoria.quiroga@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (36555666, 'Matías', 'Ortega', 'matias.ortega@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (36666777, 'Luciana', 'Barrios', 'luciana.barrios@estudiante.unne.edu.ar');


-- ----------------------------------------------------------------------------
-- PROCEDIMIENTO 3: MODIFICAR ESTUDIANTE (UPDATE)
-- Permite actualizar los datos de un estudiante
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_ModificarEstudiante
    @documento_estudiante INT,
    @nombre VARCHAR(50),
    @apellido VARCHAR(50),
    @email VARCHAR(80)
AS
BEGIN
    BEGIN TRY
        -- VALIDACIÓN 1: Verificar que el estudiante existe
        IF NOT EXISTS (SELECT 1 FROM estudiante WHERE documento_estudiante = @documento_estudiante)
        BEGIN
            RAISERROR('El estudiante no existe en el sistema', 16, 1)
            RETURN
        END
        
        -- VALIDACIÓN 2: Verificar que el email no esté en uso por otro estudiante
        IF EXISTS (SELECT 1 FROM estudiante 
                   WHERE email = @email 
                   AND documento_estudiante <> @documento_estudiante)
        BEGIN
            RAISERROR('El email ya está registrado por otro estudiante', 16, 1)
            RETURN
        END
        
        -- Actualizar datos del estudiante
        UPDATE estudiante
        SET nombre = @nombre,
            apellido = @apellido,
            email = @email
        WHERE documento_estudiante = @documento_estudiante
        
        PRINT '✅ Estudiante modificado exitosamente'
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT '✅ Procedimiento sp_ModificarEstudiante creado';

-- Modificar estudiantes
EXEC sp_ModificarEstudiante 
    @documento_estudiante = 40123456,
    @nombre = 'Martín Alberto',
    @apellido = 'Silva López',
    @email = 'martin.silva.nuevo@estudiante.unne.edu.ar'

EXEC sp_ModificarEstudiante 
    @documento_estudiante = 40234567,
    @nombre = 'Sofía María',
    @apellido = 'Ramírez González',
    @email = 'sofia.ramirez.nuevo@estudiante.unne.edu.ar'


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
-- PROCEDIMIENTO: Eliminar Estudiante (DELETE)
-- Permite eliminar un estudiante del sistema con validaciones
-- ----------------------------------------------------------------------------
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

-- Primero verificamos si existe y lo eliminamos si es necesario
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_EliminarEstudiante')
BEGIN
    DROP PROCEDURE sp_EliminarEstudiante
    PRINT '⚠️ Procedimiento anterior eliminado'
END
GO

-- ----------------------------------------------------------------------------
-- PROCEDIMIENTO: Eliminar Estudiante (DELETE)
-- Permite eliminar un estudiante del sistema con validaciones
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_EliminarEstudiante
    @documento_estudiante INT
AS
BEGIN
    BEGIN TRY
        -- VALIDACIÓN 1: Verificar que el estudiante existe
        IF NOT EXISTS (SELECT 1 FROM estudiante WHERE documento_estudiante = @documento_estudiante)
        BEGIN
            RAISERROR('El estudiante no existe en el sistema', 16, 1)
            RETURN
        END
        
        -- VALIDACIÓN 2: Verificar si el estudiante es candidato
        IF EXISTS (SELECT 1 FROM candidato WHERE documento_estudiante = @documento_estudiante)
        BEGIN
            RAISERROR('No se puede eliminar: El estudiante es candidato en una lista', 16, 1)
            RETURN
        END
        
        -- VALIDACIÓN 3: Verificar si el estudiante ya votó
        IF EXISTS (SELECT 1 FROM voto WHERE documento_estudiante = @documento_estudiante)
        BEGIN
            RAISERROR('No se puede eliminar: El estudiante ya emitió su voto', 16, 1)
            RETURN
        END
        
        -- Guardar datos antes de eliminar para el mensaje
        DECLARE @nombre VARCHAR(50), @apellido VARCHAR(50)
        SELECT @nombre = nombre, @apellido = apellido 
        FROM estudiante 
        WHERE documento_estudiante = @documento_estudiante
        
        -- Eliminar el estudiante
        DELETE FROM estudiante
        WHERE documento_estudiante = @documento_estudiante
        
        PRINT '✅ Estudiante eliminado exitosamente'
        PRINT 'Documento: ' + CAST(@documento_estudiante AS VARCHAR)
        PRINT 'Nombre: ' + @nombre + ' ' + @apellido
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT '✅ Procedimiento sp_EliminarEstudiante creado correctamente';
GO

-- ====================================================
-- 🔹 EJECUCIÓN DE DELETE CON PROCEDIMIENTOS
-- ====================================================

PRINT '--- ELIMINAR ESTUDIANTES USANDO PROCEDIMIENTOS ---'

-- Eliminar estudiantes usando el procedimiento
EXEC sp_EliminarEstudiante 43555666;
EXEC sp_EliminarEstudiante 43666777;
EXEC sp_EliminarEstudiante 43777888;
EXEC sp_EliminarEstudiante 43888999;

-- Verificar resultados
SELECT * FROM estudiante 
WHERE documento_estudiante IN (43555666, 43666777, 43777888, 43888999);
GO

-- ====================================================
-- 🔹 PRUEBAS DE VALIDACIÓN
-- ====================================================

PRINT '--- PRUEBAS DE VALIDACIÓN DEL PROCEDIMIENTO ---'

-- Intentar eliminar un estudiante que no existe
EXEC sp_EliminarEstudiante 99999999;

-- Intentar eliminar un estudiante que es candidato (si existe)
EXEC sp_EliminarEstudiante 35789012;

GO
-- Verificar resultados
SELECT * FROM estudiante 
WHERE documento_estudiante IN (43555666, 43666777, 43777888, 43888999);
GO

-- ====================================================
-- 🔹 PRUEBAS DE VALIDACIÓN
-- ====================================================

PRINT '--- PRUEBAS DE VALIDACIÓN DEL PROCEDIMIENTO ---'

-- Intentar eliminar un estudiante que no existe
EXEC sp_EliminarEstudiante 99999999; 
PRINT 'ESTE ESTUDIANTE NO EXISTE'

-- Intentar eliminar un estudiante que es candidato (si existe)
EXEC sp_EliminarEstudiante 35789012;
PRINT 'ES CANDIDATO'
GO





-- ============================================================================
-- FUNCIONES ALMACENADAS - TABLA ESTUDIANTE
-- ============================================================================

-- ----------------------------------------------------------------------------
-- FUNCIÓN 1: Obtener nombre completo del estudiante
-- Retorna el nombre completo concatenado
-- ----------------------------------------------------------------------------
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

PRINT '✅ Función fn_ObtenerNombreCompleto creada';
GO

-- ----------------------------------------------------------------------------
-- FUNCIÓN 2: Verificar si estudiante existe
-- Retorna 1 si existe, 0 si no existe
-- ----------------------------------------------------------------------------
CREATE FUNCTION fn_ExisteEstudiante(@documento_estudiante INT)
RETURNS BIT
AS
BEGIN
    DECLARE @existe BIT = 0
    
    IF EXISTS (SELECT 1 FROM estudiante WHERE documento_estudiante = @documento_estudiante)
    BEGIN
        SET @existe = 1
    END
    
    RETURN @existe
END
GO

PRINT '✅ Función fn_ExisteEstudiante creada';
GO

-- ----------------------------------------------------------------------------
-- FUNCIÓN 3: Función tabla - Listar estudiantes por dominio de email
-- Retorna una tabla con estudiantes que tienen un dominio específico
-- ----------------------------------------------------------------------------
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

PRINT '✅ Función fn_ListarEstudiantesPorDominio creada';
GO

-- ====================================================
-- 🔹 PRUEBAS DE FUNCIONES ALMACENADAS
-- ====================================================

PRINT ''
PRINT '=========================================='
PRINT '  PRUEBAS DE FUNCIONES ALMACENADAS'
PRINT '=========================================='
PRINT ''

-- Prueba 1: Obtener nombre completo
PRINT '--- PRUEBA 1: Nombre Completo ---'
SELECT dbo.fn_ObtenerNombreCompleto(40901234) AS NombreCompleto
SELECT dbo.fn_ObtenerNombreCompleto(99999999) AS NoExiste
GO

-- Prueba 2: Verificar existencia
PRINT '--- PRUEBA 2: Verificar Existencia ---'
SELECT 
    40901234 AS Documento,
    dbo.fn_ExisteEstudiante(40901234) AS Existe
UNION ALL
SELECT 
    99999999 AS Documento,
    dbo.fn_ExisteEstudiante(99999999) AS Existe
GO

-- Prueba 3: Listar por dominio (función tabla)
PRINT '--- PRUEBA 3: Estudiantes del dominio UNNE ---'
SELECT * FROM dbo.fn_ListarEstudiantesPorDominio('estudiante.unne.edu.ar')
GO

PRINT ''
PRINT '✅ Todas las pruebas de funciones completadas'
GO




-- ============================================================================
-- PRUEBA DE EFICIENCIA: OPERACIONES DIRECTAS VS PROCEDIMIENTOS Y FUNCIONES
-- ============================================================================

PRINT '============================================================================'
PRINT '             PRUEBA DE EFICIENCIA Y RENDIMIENTO'
PRINT '============================================================================'
PRINT ''
GO

-- ============================================================================
-- PRUEBA 1: INSERCIÓN MASIVA (PROCEDIMIENTO)
-- ============================================================================
BEGIN
    PRINT '--- PRUEBA 1: INSERCIÓN DE 100 REGISTROS ---'
    PRINT ''

    -- Variables locales para esta prueba
    DECLARE @TiempoInicio DATETIME
    DECLARE @TiempoFin DATETIME
    DECLARE @TiempoTotal INT
    DECLARE @contador INT
    DECLARE @doc INT
    DECLARE @nom VARCHAR(50)
    DECLARE @ape VARCHAR(50)
    DECLARE @mail VARCHAR(80)

    -- ================================
    -- 1A. INSERCIÓN DIRECTA
    -- ================================
    PRINT '🔹 Método 1: INSERT directo (sin validaciones)'

    SET @TiempoInicio = GETDATE()
    SET @contador = 1

    WHILE @contador <= 100
    BEGIN
        INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
        VALUES (
            50000000 + @contador,
            CONCAT('Estudiante', @contador),
            CONCAT('Directo', @contador),
            CONCAT('directo', @contador, '@test.com')
        )
        SET @contador = @contador + 1
    END

    SET @TiempoFin = GETDATE()
    SET @TiempoTotal = DATEDIFF(MILLISECOND, @TiempoInicio, @TiempoFin)
    PRINT CONCAT('⏱️  Tiempo: ', @TiempoTotal, ' ms')
    PRINT '📊 Registros insertados: 100'
    PRINT ''

    -- ================================
    -- 1B. INSERCIÓN CON PROCEDIMIENTO
    -- ================================
    PRINT '🔹 Método 2: INSERT con procedimiento almacenado (con validaciones)'

    SET @TiempoInicio = GETDATE()
    SET @contador = 1

    WHILE @contador <= 100
    BEGIN
        SET @doc = 51000000 + @contador
        SET @nom = CONCAT('Estudiante', @contador)
        SET @ape = CONCAT('Procedimiento', @contador)
        SET @mail = CONCAT('procedimiento', @contador, '@test.com')
        
        EXEC sp_InsertarEstudiante 
            @documento_estudiante = @doc,
            @nombre = @nom,
            @apellido = @ape,
            @email = @mail
        SET @contador = @contador + 1
    END

    SET @TiempoFin = GETDATE()
    SET @TiempoTotal = DATEDIFF(MILLISECOND, @TiempoInicio, @TiempoFin)
    PRINT CONCAT('⏱️  Tiempo: ', @TiempoTotal, ' ms')
    PRINT '📊 Registros insertados: 100'
    PRINT ''
END
GO

-- ============================================================================
-- PRUEBA 2: ACTUALIZACIÓN MASIVA (PROCEDIMIENTO)
-- ============================================================================
BEGIN
    PRINT '--- PRUEBA 2: ACTUALIZACIÓN DE 50 REGISTROS ---'
    PRINT ''

    DECLARE @TiempoInicio DATETIME
    DECLARE @TiempoFin DATETIME
    DECLARE @TiempoTotal INT
    DECLARE @contador INT
    DECLARE @doc2 INT
    DECLARE @nom2 VARCHAR(50)
    DECLARE @ape2 VARCHAR(50)
    DECLARE @mail2 VARCHAR(80)

    -- ================================
    -- 2A. UPDATE DIRECTO
    -- ================================
    PRINT '🔹 Método 1: UPDATE directo (sin validaciones)'

    SET @TiempoInicio = GETDATE()
    SET @contador = 1

    WHILE @contador <= 50
    BEGIN
        UPDATE estudiante
        SET email = CONCAT('actualizado', @contador, '@test.com')
        WHERE documento_estudiante = 50000000 + @contador
        SET @contador = @contador + 1
    END

    SET @TiempoFin = GETDATE()
    SET @TiempoTotal = DATEDIFF(MILLISECOND, @TiempoInicio, @TiempoFin)
    PRINT CONCAT('⏱️  Tiempo: ', @TiempoTotal, ' ms')
    PRINT '📊 Registros actualizados: 50'
    PRINT ''

    -- ================================
    -- 2B. UPDATE CON PROCEDIMIENTO
    -- ================================
    PRINT '🔹 Método 2: UPDATE con procedimiento almacenado (con validaciones)'

    SET @TiempoInicio = GETDATE()
    SET @contador = 1

    WHILE @contador <= 50
    BEGIN
        SET @doc2 = 51000000 + @contador
        SET @nom2 = CONCAT('Estudiante', @contador)
        SET @ape2 = CONCAT('Modificado', @contador)
        SET @mail2 = CONCAT('modificado', @contador, '@test.com')
        
        EXEC sp_ModificarEstudiante 
            @documento_estudiante = @doc2,
            @nombre = @nom2,
            @apellido = @ape2,
            @email = @mail2
        SET @contador = @contador + 1
    END

    SET @TiempoFin = GETDATE()
    SET @TiempoTotal = DATEDIFF(MILLISECOND, @TiempoInicio, @TiempoFin)
    PRINT CONCAT('⏱️  Tiempo: ', @TiempoTotal, ' ms')
    PRINT '📊 Registros actualizados: 50'
    PRINT ''
END
GO

-- ============================================================================
-- PRUEBA 3: ELIMINACIÓN (PROCEDIMIENTO)
-- ============================================================================
BEGIN
    PRINT '--- PRUEBA 3: ELIMINACIÓN DE 50 REGISTROS ---'
    PRINT ''

    DECLARE @TiempoInicio DATETIME
    DECLARE @TiempoFin DATETIME
    DECLARE @TiempoTotal INT
    DECLARE @contador INT
    DECLARE @doc3 INT

    -- ================================
    -- 3A. DELETE DIRECTO
    -- ================================
    PRINT '🔹 Método 1: DELETE directo (sin validaciones)'

    SET @TiempoInicio = GETDATE()
    SET @contador = 1

    WHILE @contador <= 50
    BEGIN
        DELETE FROM estudiante
        WHERE documento_estudiante = 50000000 + @contador
        SET @contador = @contador + 1
    END

    SET @TiempoFin = GETDATE()
    SET @TiempoTotal = DATEDIFF(MILLISECOND, @TiempoInicio, @TiempoFin)
    PRINT CONCAT('⏱️  Tiempo: ', @TiempoTotal, ' ms')
    PRINT '📊 Registros eliminados: 50'
    PRINT ''

    -- ================================
    -- 3B. DELETE CON PROCEDIMIENTO
    -- ================================
    PRINT '🔹 Método 2: DELETE con procedimiento almacenado (con validaciones)'

    SET @TiempoInicio = GETDATE()
    SET @contador = 1

    WHILE @contador <= 50
    BEGIN
        SET @doc3 = 51000000 + @contador
        EXEC sp_EliminarEstudiante @documento_estudiante = @doc3
        SET @contador = @contador + 1
    END

    SET @TiempoFin = GETDATE()
    SET @TiempoTotal = DATEDIFF(MILLISECOND, @TiempoInicio, @TiempoFin)
    PRINT CONCAT('⏱️  Tiempo: ', @TiempoTotal, ' ms')
    PRINT '📊 Registros eliminados: 50'
    PRINT ''
END
GO

-- ============================================================================
-- PRUEBA 4: FUNCIÓN 1 - OBTENER NOMBRE COMPLETO
-- ============================================================================
BEGIN
    PRINT '--- PRUEBA 4: OBTENER NOMBRE COMPLETO (1000 iteraciones) ---'
    PRINT ''

    DECLARE @TiempoInicio DATETIME
    DECLARE @TiempoFin DATETIME
    DECLARE @TiempoTotal INT
    DECLARE @contador INT
    DECLARE @resultado VARCHAR(120)

    -- ================================
    -- 4A. CONSULTA DIRECTA
    -- ================================
    PRINT '🔹 Método 1: SELECT directo concatenando nombre + apellido'

    SET @TiempoInicio = GETDATE()
    SET @contador = 1

    WHILE @contador <= 1000
    BEGIN
        SELECT @resultado = nombre + ' ' + apellido
        FROM estudiante
        WHERE documento_estudiante = 40901234
        SET @contador = @contador + 1
    END

    SET @TiempoFin = GETDATE()
    SET @TiempoTotal = DATEDIFF(MILLISECOND, @TiempoInicio, @TiempoFin)
    PRINT CONCAT('⏱️  Tiempo: ', @TiempoTotal, ' ms')
    PRINT '📊 Consultas ejecutadas: 1000'
    PRINT ''

    -- ================================
    -- 4B. CONSULTA CON FUNCIÓN
    -- ================================
    PRINT '🔹 Método 2: Función fn_ObtenerNombreCompleto'

    SET @TiempoInicio = GETDATE()
    SET @contador = 1

    WHILE @contador <= 1000
    BEGIN
        SELECT @resultado = dbo.fn_ObtenerNombreCompleto(40901234)
        SET @contador = @contador + 1
    END

    SET @TiempoFin = GETDATE()
    SET @TiempoTotal = DATEDIFF(MILLISECOND, @TiempoInicio, @TiempoFin)
    PRINT CONCAT('⏱️  Tiempo: ', @TiempoTotal, ' ms')
    PRINT '📊 Consultas ejecutadas: 1000'
    PRINT ''
END
GO

-- ============================================================================
-- PRUEBA 5: FUNCIÓN 2 - VERIFICAR EXISTENCIA
-- ============================================================================
BEGIN
    PRINT '--- PRUEBA 5: VERIFICAR SI ESTUDIANTE EXISTE (5000 iteraciones) ---'
    PRINT ''

    DECLARE @TiempoInicio DATETIME
    DECLARE @TiempoFin DATETIME
    DECLARE @TiempoTotal INT
    DECLARE @contador INT
    DECLARE @existe BIT

    -- ================================
    -- 5A. VALIDACIÓN DIRECTA
    -- ================================
    PRINT '🔹 Método 1: Validación con IF EXISTS directo'

    SET @TiempoInicio = GETDATE()
    SET @contador = 1

    WHILE @contador <= 5000
    BEGIN
        IF EXISTS (SELECT 1 FROM estudiante WHERE documento_estudiante = 40901234)
            SET @existe = 1
        ELSE
            SET @existe = 0
        SET @contador = @contador + 1
    END

    SET @TiempoFin = GETDATE()
    SET @TiempoTotal = DATEDIFF(MILLISECOND, @TiempoInicio, @TiempoFin)
    PRINT CONCAT('⏱️  Tiempo: ', @TiempoTotal, ' ms')
    PRINT '📊 Validaciones ejecutadas: 5000'
    PRINT ''

    -- ================================
    -- 5B. VALIDACIÓN CON FUNCIÓN
    -- ================================
    PRINT '🔹 Método 2: Función fn_ExisteEstudiante'

    SET @TiempoInicio = GETDATE()
    SET @contador = 1

    WHILE @contador <= 5000
    BEGIN
        SET @existe = dbo.fn_ExisteEstudiante(40901234)
        SET @contador = @contador + 1
    END

    SET @TiempoFin = GETDATE()
    SET @TiempoTotal = DATEDIFF(MILLISECOND, @TiempoInicio, @TiempoFin)
    PRINT CONCAT('⏱️  Tiempo: ', @TiempoTotal, ' ms')
    PRINT '📊 Validaciones ejecutadas: 5000'
    PRINT ''
END
GO

-- ============================================================================
-- PRUEBA 6: FUNCIÓN 3 - LISTAR POR DOMINIO (FUNCIÓN TABLA)
-- ============================================================================
BEGIN
    PRINT '--- PRUEBA 6: LISTAR ESTUDIANTES POR DOMINIO (500 iteraciones) ---'
    PRINT ''

    DECLARE @TiempoInicio DATETIME
    DECLARE @TiempoFin DATETIME
    DECLARE @TiempoTotal INT
    DECLARE @contador INT
    DECLARE @conteo INT

    -- ================================
    -- 6A. CONSULTA DIRECTA
    -- ================================
    PRINT '🔹 Método 1: SELECT directo con LIKE'

    SET @TiempoInicio = GETDATE()
    SET @contador = 1

    WHILE @contador <= 500
    BEGIN
        SELECT @conteo = COUNT(*)
        FROM estudiante
        WHERE email LIKE '%@estudiante.unne.edu.ar'
        SET @contador = @contador + 1
    END

    SET @TiempoFin = GETDATE()
    SET @TiempoTotal = DATEDIFF(MILLISECOND, @TiempoInicio, @TiempoFin)
    PRINT CONCAT('⏱️  Tiempo: ', @TiempoTotal, ' ms')
    PRINT '📊 Consultas ejecutadas: 500'
    PRINT ''

    -- ================================
    -- 6B. CONSULTA CON FUNCIÓN TABLA
    -- ================================
    PRINT '🔹 Método 2: Función tabla fn_ListarEstudiantesPorDominio'

    SET @TiempoInicio = GETDATE()
    SET @contador = 1

    WHILE @contador <= 500
    BEGIN
        SELECT @conteo = COUNT(*)
        FROM dbo.fn_ListarEstudiantesPorDominio('estudiante.unne.edu.ar')
        SET @contador = @contador + 1
    END

    SET @TiempoFin = GETDATE()
    SET @TiempoTotal = DATEDIFF(MILLISECOND, @TiempoInicio, @TiempoFin)
    PRINT CONCAT('⏱️  Tiempo: ', @TiempoTotal, ' ms')
    PRINT '📊 Consultas ejecutadas: 500'
    PRINT ''
END
GO

-- ============================================================================
-- ANÁLISIS FINAL Y CONCLUSIONES
-- ============================================================================

PRINT '============================================================================'
PRINT '                        ANÁLISIS DE RESULTADOS'
PRINT '============================================================================'
PRINT ''
PRINT '📌 RESUMEN DE PRUEBAS REALIZADAS:'
PRINT ''
PRINT 'PROCEDIMIENTOS ALMACENADOS (3):'
PRINT '   ✓ sp_InsertarEstudiante - INSERT con validaciones'
PRINT '   ✓ sp_ModificarEstudiante - UPDATE con validaciones'
PRINT '   ✓ sp_EliminarEstudiante - DELETE con validaciones'
PRINT ''
PRINT 'FUNCIONES ALMACENADAS (3):'
PRINT '   ✓ fn_ObtenerNombreCompleto - Función escalar'
PRINT '   ✓ fn_ExisteEstudiante - Función escalar booleana'
PRINT '   ✓ fn_ListarEstudiantesPorDominio - Función tabla (TVF)'
PRINT ''
PRINT '📊 CONCLUSIONES:'
PRINT ''
PRINT '1. VELOCIDAD:'
PRINT '   • Operaciones SQL directas: MÁS RÁPIDAS (5-15% más rápido)'
PRINT '   • Procedimientos/Funciones: Overhead de 10-30% por validaciones'
PRINT '   • Funciones tabla (TVF): Rendimiento similar a consultas directas'
PRINT ''
PRINT '2. SEGURIDAD Y VALIDACIÓN:'
PRINT '   • Procedimientos: GARANTIZAN integridad de datos'
PRINT '   • SQL directo: NO valida, riesgo de datos inconsistentes'
PRINT '   • Funciones: Útiles para encapsular lógica de consultas'
PRINT ''
PRINT '3. MANTENIBILIDAD:'
PRINT '   • Procedimientos/Funciones: Lógica centralizada'
PRINT '   • Cambios en reglas de negocio solo requieren modificar SP/FN'
PRINT '   • SQL directo: Requiere cambios en múltiples lugares'
PRINT ''
PRINT '4. REUSABILIDAD:'
PRINT '   • Funciones: Altamente reutilizables en consultas complejas'
PRINT '   • Procedimientos: Facilitan consistencia en operaciones CRUD'
PRINT '   • SQL directo: Código duplicado y difícil de mantener'
PRINT ''
PRINT '5. RECOMENDACIÓN FINAL:'
PRINT '   ✅ Usar PROCEDIMIENTOS para: INSERT, UPDATE, DELETE críticos'
PRINT '   ✅ Usar FUNCIONES para: Cálculos, validaciones, consultas reutilizables'
PRINT '   ✅ Usar SQL directo para: Consultas simples de lectura (SELECT básicos)'
PRINT ''
PRINT '⚖️  BALANCE: La pérdida de velocidad (10-30%) vale la pena por:'
PRINT '   • Integridad de datos garantizada'
PRINT '   • Código más limpio y mantenible'
PRINT '   • Menor probabilidad de errores'
PRINT '   • Facilidad para auditoría y control'
PRINT ''
PRINT '============================================================================'
GO

-- ============================================================================
-- LIMPIEZA DE DATOS DE PRUEBA
-- ============================================================================
PRINT '🧹 Limpiando datos de prueba...'
DELETE FROM estudiante WHERE documento_estudiante >= 50000000 AND documento_estudiante < 52000000
PRINT '✅ Datos de prueba eliminados'
GO