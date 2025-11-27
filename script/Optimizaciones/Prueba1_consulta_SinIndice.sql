---------------------------------------------------------------------------
---------------------------------------------------------------------------
			      -- PRUEBA 1: CONSULTA SIN ÍNDICE  --
---------------------------------------------------------------------------
-- ** Objetivo **
-- Medir el rendimiento de una búsqueda por rango de fechas '2025-11-17' y 
-- '2025-11-18'cuando la tabla NO posee ningún índice en la columna fecha_emision.

-- ** Justificación ** 
-- Esta prueba sirve como "punto de comparación" para evaluar posteriormente 
-- la mejora de rendimiento al aplicar distintos tipos de índices.  
-- Al no tener índices sobre fecha_emision, SQL Server debe recorrer toda la 
-- tabla para identificar qué filas cumplen el filtro temporal.

---------------------------------------------------------------------------
        -- 1. LIMPIEZA DE ÍNDICES (para asegurar una prueba justa)

-- Se eliminan cualquier índice previo que haya quedado de pruebas 
-- anteriores, asegurando así que SQL Server no utilice ninguna estructura 
-- que acelere la búsqueda.
---------------------------------------------------------------------------

-- 1A. Eliminar índice covering si existe
IF EXISTS (SELECT 1 FROM sys.indexes 
           WHERE name = 'IX_auditoria_votos_fecha_COVERING')
    DROP INDEX IX_auditoria_votos_fecha_COVERING ON auditoria_votos;
GO

-- 1B. Eliminar el índice clustered que quedó de Prueba 2
IF EXISTS (SELECT 1 FROM sys.indexes 
           WHERE name = 'IX_auditoria_votos_fecha')
    DROP INDEX IX_auditoria_votos_fecha ON auditoria_votos;
GO

-- 1C. Restaurar la PK como CLUSTERED (original)
IF EXISTS (SELECT 1 FROM sys.key_constraints
           WHERE name = 'PK_auditoria_votos')
BEGIN
    ALTER TABLE auditoria_votos DROP CONSTRAINT PK_auditoria_votos;
END
GO

ALTER TABLE auditoria_votos
ADD CONSTRAINT PK_auditoria_votos PRIMARY KEY CLUSTERED (id);
GO


---------------------------------------------------------------------------
                    -- 2. LIMPIAR CACHÉS DEL MOTOR
--    Esto garantiza que la medición sea real y no dependa de páginas ya 
--    almacenadas en memoria.
---------------------------------------------------------------------------
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO


---------------------------------------------------------------------------
                        -- 3. CONSULTA SIN ÍNDICE
---------------------------------------------------------------------------
-- 1. Activar estadísticas
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- 2. CONSULTA DE PRUEBA
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
--   - Tiempo de CPU: 203 ms
--   - Tiempo transcurrido: 1156 ms 
--   - Lecturas lógicas: 560 páginas
--   - Operación: Clustered Index SCAN (tuvo que leer toda la tabla)

-- SQL Server tuvo que leer absolutamente todas las páginas de la tabla 
-- (560 páginas) para determinar qué filas cumplían con el rango de fechas.  
-- Esto se debe a que no existe ningún índice sobre la columna fecha_emision, 
-- por lo tanto el motor se ve obligado a recorrer la tabla completa.
---------------------------------------------------------------------------