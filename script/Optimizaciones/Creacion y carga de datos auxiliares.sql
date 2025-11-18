-- ========================================================================
-- La tabla voto del sistema electoral no está diseñada para recibir
-- cientos de miles de registros de prueba. Posee dependencias con:
-- - token_votante (FK obligatoria)
-- - lista (FK obligatoria)
-- - mesa_votacion (FK obligatoria)
-- Generar 100.000 votos reales implicaria entre otras cosas, violar 
-- restricciones y comprometer a la integridad del sistema.

-- OBJETIVOS 
-- El trabajo requiere evaluar ÍNDICES, no el modelo de negocio.
-- Se implementó una tabla de auditoría denominada auditoria_votos que simula 
-- un log de eventos del sistema electoral. Esta tabla fue diseñada específicamente 
-- para las pruebas de rendimiento, evitando comprometer la integridad referencial 
-- y las restricciones de negocio del modelo productivo. La tabla almacena 100,000 
-- eventos con timestamps variables, permitiendo evaluar el impacto de diferentes 
-- estrategias de indexación en consultas por rango de fechas.
-- ========================================================================
---------------------------------------------------------------------------
			-- 1. CREAR TABLA DE AUDITORIA --
---------------------------------------------------------------------------
CREATE TABLE auditoria_votos
(
    id INT IDENTITY(1,1) NOT NULL,
    fecha_emision DATETIME2 NOT NULL,
    mesa INT NOT NULL,
    lista INT NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    CONSTRAINT PK_auditoria_votos PRIMARY KEY CLUSTERED (id)
);
GO

PRINT 'Tabla auditoria_votos creada exitosamente.';
GO

-- Verificar que se creó
SELECT COUNT(*) AS Registros_Actuales FROM auditoria_votos;
GO



---------------------------------------------------------------------------
			-- 2. CARGA MASIVA DE 100,000 REGISTROS --
---------------------------------------------------------------------------


SET NOCOUNT ON;

DECLARE @contador INT = 1;
DECLARE @lote INT = 5000;
DECLARE @total INT = 100000;
DECLARE @fecha_base DATETIME2 = GETDATE();

WHILE @contador <= @total
BEGIN
    INSERT INTO auditoria_votos (fecha_emision, mesa, lista, descripcion)
    SELECT 
        DATEADD(SECOND, -(n + @contador), @fecha_base) AS fecha_emision,
        (n + @contador) % 50 + 1 AS mesa,
        (n + @contador) % 5 + 1 AS lista,
        CONCAT('Evento_', n + @contador) AS descripcion
    FROM (
        SELECT TOP (@lote) 
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
        FROM sys.all_objects a
        CROSS JOIN sys.all_objects b
    ) AS numeros
    WHERE @contador + n <= @total;
    
    SET @contador = @contador + @lote;
    
    IF @contador % 20000 = 0
        PRINT '  → Insertados ' + CAST(@contador AS VARCHAR(10)) + ' registros...';
END

PRINT '';
PRINT 'Carga completada: ' + CAST(@total AS VARCHAR(10)) + ' registros';
PRINT 'Fin: ' + CONVERT(VARCHAR(30), GETDATE(), 121);
GO

-- Verificar cuántos registros tenemos
SELECT COUNT(*) AS Total_Registros FROM auditoria_votos;
