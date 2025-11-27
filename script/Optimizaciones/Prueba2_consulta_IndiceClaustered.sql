---------------------------------------------------------------------------
---------------------------------------------------------------------------
            -- PRUEBA 2 – ÍNDICE CLUSTERED SOBRE fecha_emision
---------------------------------------------------------------------------
-- ** Objetivo **
-- Medir la mejora en rendimiento al volver la columna fecha_emision la clave 
-- CLUSTERED de la tabla, lo que ordena físicamente los datos por fecha.

-- ** Justificación ** 
-- Esto permite que SQL Server acceda únicamente al segmento de datos que 
-- pertenece al rango consultado, evitando recorrer toda la tabla.
---------------------------------------------------------------------------

---------------------------------------------------------------------------
                -- 1. LIMPIEZA DE ÍNDICES EXISTENTES
-- Garantiza que no haya índices previos que alteren los resultados.
---------------------------------------------------------------------------

-- 1A. Borrar covering si existe
IF EXISTS (SELECT 1 
           FROM sys.indexes 
           WHERE name = 'IX_auditoria_votos_fecha_COVERING')
    DROP INDEX IX_auditoria_votos_fecha_COVERING ON auditoria_votos;
GO

-- 1B. Borrar índice clustered en fecha si existe
IF EXISTS (SELECT 1 
           FROM sys.indexes 
           WHERE name = 'IX_auditoria_votos_fecha')
    DROP INDEX IX_auditoria_votos_fecha ON auditoria_votos;
GO

-- 1C. Quitar la PK si existe
IF EXISTS (SELECT 1 FROM sys.key_constraints 
           WHERE parent_object_id = OBJECT_ID('auditoria_votos')
                AND name = 'PK_auditoria_votos')
BEGIN
    ALTER TABLE auditoria_votos 
    DROP CONSTRAINT PK_auditoria_votos;
END
GO

-- 1D. Restaurar PK como CLUSTERED (estado limpio)
ALTER TABLE auditoria_votos
ADD CONSTRAINT PK_auditoria_votos PRIMARY KEY CLUSTERED (id);
GO


---------------------------------------------------------------------------
			-- 2. CREAR ÍNDICE CLUSTERED EN fecha_emision
---------------------------------------------------------------------------

-- 2A. Eliminar constraint de PK clustered
ALTER TABLE auditoria_votos 
DROP CONSTRAINT PK_auditoria_votos;
GO

-- 2B. Recrear PK como NONCLUSTERED
ALTER TABLE auditoria_votos 
ADD CONSTRAINT PK_auditoria_votos PRIMARY KEY NONCLUSTERED (id);
GO

-- 2C. Crear índice CLUSTERED en fecha_emision
CREATE CLUSTERED INDEX IX_auditoria_votos_fecha
ON auditoria_votos(fecha_emision DESC);
GO


---------------------------------------------------------------------------
                    -- 3. LIMPIAR CACHÉS DEL MOTOR
-- Esto garantiza que la medición sea real y no dependa de páginas ya 
-- almacenadas en memoria.
---------------------------------------------------------------------------
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO


---------------------------------------------------------------------------
                  -- 4. CONSULTA CON ÍNDICE CLUSTERED
---------------------------------------------------------------------------
-- 1. Activar estadísticas
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- MISMA CONSULTA
SELECT 
    id,
    fecha_emision,
    mesa,
    lista
FROM auditoria_votos
WHERE fecha_emision BETWEEN '2025-11-17' AND '2025-11-18'
ORDER BY fecha_emision DESC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

---------------------------------------------------------------------------
-- Datos obtenidos:
--   - Tiempo de CPU: 125 ms
--   - Tiempo transcurrido: 1064 ms 
--   - Lecturas lógicas: 458 páginas 
--   - Operación: Clustered Index Seek 

-- SQL Server pudo dirigirse directamente al rango de fechas consultado, 
-- realizando un SEEK en lugar del SCAN completo de la Prueba 1.
-- Esto redujo:
--   - el tiempo total
--   - el número de páginas leídas (102 páginas menos)
---------------------------------------------------------------------------