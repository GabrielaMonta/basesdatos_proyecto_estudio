---------------------------------------------------------------------------
-- Se solicitan los eventos de los últimos 7 días ordenados por fecha 
-- descendente.
-- Sin índice en fecha_emision, el motor debe realizar un CLUSTERED INDEX SCAN
-- completo sobre la PK (id), examinando TODOS los 100,000 fila por fila para 
-- encontrar las fechas que cumplen.
-- Esto resulta en un alto número de lecturas de página.
-- Resultado esperado:
--   Tiempo: ALTO
--   I/O: MUY ALTO (muchas lecturas lógicas)
---------------------------------------------------------------------------

---------------------------------------------------------------------------
			-- PRUEBA 1: CONSULTA SIN ÍNDICE (BASELINE)' --
---------------------------------------------------------------------------

-- Limpiar caché para medición precisa
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO

-- Activar estadísticas
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- CONSULTA DE PRUEBA
SELECT 
    id,
    fecha_emision,
    mesa,
    lista,
    descripcion
FROM auditoria_votos
WHERE fecha_emision >= DATEADD(DAY, -7, GETDATE())
  AND fecha_emision < GETDATE()
ORDER BY fecha_emision DESC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

---------------------------------------------------------------------------
-- Datos obtenidos:
--   -Tiempo de CPU: 250 ms
--   -Tiempo transcurrido: 1890 ms (1.89 segundos)
--   -Lecturas lógicas: 560 páginas
--   -Operación: Clustered Index SCAN (tuvo que leer toda la tabla)

-- SQL Server tuvo que escanear las 560 páginas completas para encontrar los registros 
-- de los últimos 7 días. Esto es ineficiente.
---------------------------------------------------------------------------

