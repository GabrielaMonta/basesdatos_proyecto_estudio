---------------------------------------------------------------------------
---------------------------------------------------------------------------
          -- PRUEBA 3 – ÍNDICE NONCLUSTERED CON INCLUDE (COVERING)
---------------------------------------------------------------------------
-- ** Objetivo **
-- Medir el rendimiento de un índice NONCLUSTERED sobre fecha_emision que,
-- además, incluya las columnas mesa y lista.  
-- Este tipo de índice cubre totalmente la consulta, evitando Key Lookups.

-- ** Justificación **
-- Un índice nonclustered permite mantener la tabla ordenada por la PK
-- clustered original (id), lo cual preserva el diseño base.
--  - Agregar columnas con INCLUDE permite que la consulta recupere todos los 
--    datos necesarios directamente desde el índice, sin leer la tabla completa.
--  - Esto reduce I/O y vuelve la búsqueda por rango aún más eficiente.
---------------------------------------------------------------------------

---------------------------------------------------------------------------
                   -- 1. LIMPIEZA DE ÍNDICES PREVIOS
-- Garantiza que solo influya el índice que estamos evaluando.
---------------------------------------------------------------------------

-- 1A. Borrar índice covering si existe
IF EXISTS (SELECT 1 
           FROM sys.indexes 
           WHERE name = 'IX_auditoria_votos_fecha_COVERING')
    DROP INDEX IX_auditoria_votos_fecha_COVERING ON auditoria_votos;
GO

-- 1B. Borrar índice clustered de fecha si existe (de Prueba 2)
IF EXISTS (SELECT 1 
           FROM sys.indexes 
           WHERE name = 'IX_auditoria_votos_fecha')
    DROP INDEX IX_auditoria_votos_fecha ON auditoria_votos;
GO

-- 1C. Restaurar PK como CLUSTERED (estado original de la tabla)
IF EXISTS (
    SELECT 1 FROM sys.key_constraints
    WHERE parent_object_id = OBJECT_ID('auditoria_votos')
      AND name = 'PK_auditoria_votos'
)
BEGIN
    ALTER TABLE auditoria_votos DROP CONSTRAINT PK_auditoria_votos;
END
GO

ALTER TABLE auditoria_votos
ADD CONSTRAINT PK_auditoria_votos PRIMARY KEY CLUSTERED (id);
GO


---------------------------------------------------------------------------
        -- 2. CREAR ÍNDICE NONCLUSTERED CON INCLUDE (COVERING)
-- Este índice optimiza la consulta sin alterar el orden físico de la tabla.
---------------------------------------------------------------------------

CREATE NONCLUSTERED INDEX IX_auditoria_votos_fecha_COVERING
ON auditoria_votos(fecha_emision DESC)
INCLUDE (mesa, lista);
GO


---------------------------------------------------------------------------
                    -- 2. LIMPIAR CACHÉS DEL MOTOR
-- Esto garantiza que la medición sea real y no dependa de páginas ya 
-- almacenadas en memoria.
---------------------------------------------------------------------------
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO


---------------------------------------------------------------------------
          -- 3: CONSULTA CON ÍNDICE NONCLUSTERED + INCLUDE
-- Usamos el mismo rango que en Pruebas 1 y 2.
---------------------------------------------------------------------------
-- 1. Activar estadísticas
SET STATISTICS TIME ON;
SET STATISTICS IO ON;


-- 2. Misma consulta
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
--   - Tiempo de CPU: 78 ms
--   - Tiempo transcurrido: 1074 ms 
--   - Lecturas lógicas: 255 páginas
--   - Operación: Index Seek (NonClaustered)

-- Con estos datos podemos concluir que el Indice Covering es mejor porque:
--   - Tenemos menos lecturas: 560 (Prueba 1) vs 255 páginas
--   - Sin Key Lookup: Todo se resuelve desde el índice
--   - Mantiene flexibilidad: La PK sigue siendo clustered en id
---------------------------------------------------------------------------