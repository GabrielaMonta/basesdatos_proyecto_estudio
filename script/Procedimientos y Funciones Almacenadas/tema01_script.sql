CREATE DATABASE proyecto_elecciones;
GO

USE proyecto_elecciones;
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

-- ----------------------------------------------------------------------------
-- PROCEDIMIENTO 1: Registrar voto (INSERT)
-- Permite que un estudiante emita su voto usando su token
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_RegistrarVoto
    @token_id INT,
    @lista_id INT,
    @mesa_votacion_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- VALIDACIÓN 1: Verificar que el token existe
        IF NOT EXISTS (SELECT 1 FROM token_votante WHERE token_id = @token_id)
        BEGIN
            RAISERROR('El token no existe en el sistema', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
        
        -- VALIDACIÓN 2: Verificar que el token no fue usado
        IF EXISTS (SELECT 1 FROM token_votante WHERE token_id = @token_id AND usado = 1)
        BEGIN
            RAISERROR('Este token ya fue utilizado para votar', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
        
        -- VALIDACIÓN 3: Verificar que la lista existe
        IF NOT EXISTS (SELECT 1 FROM lista WHERE lista_id = @lista_id)
        BEGIN
            RAISERROR('La lista seleccionada no existe', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
        
        -- VALIDACIÓN 4: Verificar que la mesa existe
        IF NOT EXISTS (SELECT 1 FROM mesa_votacion WHERE mesa_votacion_id = @mesa_votacion_id)
        BEGIN
            RAISERROR('La mesa de votación no existe', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
        
        -- Registrar el voto
        INSERT INTO voto (token_id, fecha_emision, lista_id, mesa_votacion_id)
        VALUES (@token_id, SYSDATETIME(), @lista_id, @mesa_votacion_id)
        
        -- Marcar el token como usado
        UPDATE token_votante
        SET usado = 1
        WHERE token_id = @token_id
        
        COMMIT TRANSACTION
        PRINT '✅ Voto registrado exitosamente'
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT '✅ Procedimiento sp_RegistrarVoto creado';
GO

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
GO

-- ----------------------------------------------------------------------------
-- PROCEDIMIENTO 4: ELIMINAR LISTA (DELETE)
-- Elimina una lista electoral si no tiene votos registrados
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_EliminarLista
    @lista_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- VALIDACIÓN 1: Verificar que la lista existe
        IF NOT EXISTS (SELECT 1 FROM lista WHERE lista_id = @lista_id)
        BEGIN
            RAISERROR('La lista no existe en el sistema', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
        
        -- VALIDACIÓN 2: Verificar que la lista no tenga votos
        IF EXISTS (SELECT 1 FROM voto WHERE lista_id = @lista_id)
        BEGIN
            RAISERROR('No se puede eliminar una lista que tiene votos registrados', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
        
        -- VALIDACIÓN 3: Verificar que no esté en resultados
        IF EXISTS (SELECT 1 FROM resultado_eleccion WHERE lista_id = @lista_id)
        BEGIN
            RAISERROR('No se puede eliminar una lista que tiene resultados registrados', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
        
        -- VALIDACIÓN 4: Verificar que no esté en escrutinio de mesas
        IF EXISTS (SELECT 1 FROM escrutinio_mesa WHERE lista_id = @lista_id)
        BEGIN
            RAISERROR('No se puede eliminar una lista con escrutinios registrados', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
        
        -- Eliminar relaciones (candidatos de la lista)
        DELETE FROM lista_cargos WHERE lista_id = @lista_id
        
        -- Eliminar la lista
        DELETE FROM lista WHERE lista_id = @lista_id
        
        COMMIT TRANSACTION
        PRINT '✅ Lista eliminada exitosamente'
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT '✅ Procedimiento sp_EliminarLista creado';
GO

-- ============================================================================
-- PARTE 4: FUNCIONES ALMACENADAS (4 REQUERIDAS)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- FUNCIÓN 1: CALCULAR PORCENTAJE DE VOTOS DE UNA LISTA
-- Retorna el porcentaje de votos que obtuvo una lista
-- ----------------------------------------------------------------------------
CREATE FUNCTION fn_PorcentajeVotosLista
(
    @lista_id INT,
    @eleccion_id INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @votos_lista INT
    DECLARE @votos_totales INT
    DECLARE @porcentaje DECIMAL(5,2)
    
    -- Contar votos de la lista específica
    SELECT @votos_lista = COUNT(*)
    FROM voto v
    INNER JOIN token_votante tv ON v.token_id = tv.token_id
    INNER JOIN mesa_identificacion mi ON tv.mesa_identificacion_id = mi.mesa_identificacion_id
    WHERE v.lista_id = @lista_id
    AND mi.eleccion_id = @eleccion_id
    
    -- Contar total de votos de la elección
    SELECT @votos_totales = COUNT(*)
    FROM voto v
    INNER JOIN token_votante tv ON v.token_id = tv.token_id
    INNER JOIN mesa_identificacion mi ON tv.mesa_identificacion_id = mi.mesa_identificacion_id
    WHERE mi.eleccion_id = @eleccion_id
    
    -- Calcular porcentaje
    IF @votos_totales > 0
        SET @porcentaje = (@votos_lista * 100.0) / @votos_totales
    ELSE
        SET @porcentaje = 0
    
    RETURN @porcentaje
END
GO

PRINT '✅ Función fn_PorcentajeVotosLista creada';
GO

-- ----------------------------------------------------------------------------
-- FUNCIÓN 2: CONTAR VOTOS DE UNA LISTA
-- Retorna la cantidad total de votos de una lista en una elección
-- ----------------------------------------------------------------------------
CREATE FUNCTION fn_ContarVotosLista
(
    @lista_id INT,
    @eleccion_id INT
)
RETURNS INT
AS
BEGIN
    DECLARE @cantidad_votos INT
    
    SELECT @cantidad_votos = COUNT(*)
    FROM voto v
    INNER JOIN token_votante tv ON v.token_id = tv.token_id
    INNER JOIN mesa_identificacion mi ON tv.mesa_identificacion_id = mi.mesa_identificacion_id
    WHERE v.lista_id = @lista_id
    AND mi.eleccion_id = @eleccion_id
    
    RETURN ISNULL(@cantidad_votos, 0)
END
GO

PRINT '✅ Función fn_ContarVotosLista creada';
GO

-- ----------------------------------------------------------------------------
-- FUNCIÓN 3: CALCULAR PARTICIPACIÓN ELECTORAL
-- Retorna el porcentaje de estudiantes que votaron
-- ----------------------------------------------------------------------------
CREATE FUNCTION fn_ParticipacionElectoral
(
    @eleccion_id INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @total_habilitados INT
    DECLARE @total_votantes INT
    DECLARE @participacion DECIMAL(5,2)
    
    -- Contar estudiantes habilitados
    SELECT @total_habilitados = COUNT(*)
    FROM mesa_identificacion
    WHERE eleccion_id = @eleccion_id
    
    -- Contar tokens usados (votantes)
    SELECT @total_votantes = COUNT(*)
    FROM token_votante tv
    INNER JOIN mesa_identificacion mi ON tv.mesa_identificacion_id = mi.mesa_identificacion_id
    WHERE mi.eleccion_id = @eleccion_id
    AND tv.usado = 1
    
    -- Calcular participación
    IF @total_habilitados > 0
        SET @participacion = (@total_votantes * 100.0) / @total_habilitados
    ELSE
        SET @participacion = 0
    
    RETURN @participacion
END
GO

PRINT '✅ Función fn_ParticipacionElectoral creada';
GO
-- ----------------------------------------------------------------------------
-- FUNCIÓN 4: CALCULAR EDAD DEL ESTUDIANTE
-- Retorna la edad del estudianbte
-- ----------------------------------------------------------------------------
CREATE FUNCTION fn_CalcularEdadEstudiante
(
    @fecha_nacimiento DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @edad INT
    
    SET @edad = DATEDIFF(YEAR, @fecha_nacimiento, GETDATE()) -
                CASE 
                    WHEN MONTH(@fecha_nacimiento) > MONTH(GETDATE()) 
                         OR (MONTH(@fecha_nacimiento) = MONTH(GETDATE()) 
                             AND DAY(@fecha_nacimiento) > DAY(GETDATE()))
                    THEN 1
                    ELSE 0
                END
    
    RETURN @edad
END
GO

-- ============================================================================
-- PARTE 5: Insert de Votos usando procedimientos
-- ============================================================================

PRINT ''
PRINT '============================================'
PRINT 'PRUEBAS DE PROCEDIMIENTOS'
PRINT '============================================'
PRINT ''

-- Registrar votos usando el procedimiento
EXEC sp_RegistrarVoto @token_id = 1, @lista_id = 1, @mesa_votacion_id = 1
EXEC sp_RegistrarVoto @token_id = 2, @lista_id = 1, @mesa_votacion_id = 1
EXEC sp_RegistrarVoto @token_id = 3, @lista_id = 2, @mesa_votacion_id = 2
EXEC sp_RegistrarVoto @token_id = 4, @lista_id = 2, @mesa_votacion_id = 2
EXEC sp_RegistrarVoto @token_id = 5, @lista_id = 3, @mesa_votacion_id = 3
EXEC sp_RegistrarVoto @token_id = 6, @lista_id = 1, @mesa_votacion_id = 3
EXEC sp_RegistrarVoto @token_id = 7, @lista_id = 3, @mesa_votacion_id = 4






PRINT ''
PRINT '============================================'
PRINT 'OPERACIONES UPDATE'
PRINT '============================================'
PRINT ''

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

PRINT ''
PRINT '============================================'
PRINT 'CONSULTAS CON FUNCIONES'
PRINT '============================================'
PRINT ''


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






