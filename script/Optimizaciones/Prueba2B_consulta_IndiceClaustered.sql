---------------------------------------------------------------------------
-- Se realiza la consulta con 1 hora en lugar de 7 días para ver la 
-- diferencia real
-- Resultado esperado: menos de 10 páginas en lecturas lógicas
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--      PRUEBA 2.B: CONSULTA CON RANGO PEQUEÑO (1 HORA)
---------------------------------------------------------------------------

-- Limpiar caché
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- Consulta con RANGO PEQUEÑO (1 hora)
SELECT 
    id,
    fecha_emision,
    mesa,
    lista,
    descripcion
FROM auditoria_votos
WHERE fecha_emision >= DATEADD(HOUR, -1, GETDATE())
  AND fecha_emision < GETDATE()
ORDER BY fecha_emision DESC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

---------------------------------------------------------------------------
-- Datos obtenidos:
--   -Tiempo transcurrido: 221 ms 
--   -Lecturas lógicas: 20 páginas 
---------------------------------------------------------------------------