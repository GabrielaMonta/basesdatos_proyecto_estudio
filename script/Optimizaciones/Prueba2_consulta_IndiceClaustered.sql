---------------------------------------------------------------------------
-- Se crea un índice clustered en fecha_emision para ver la mejora.
-- Esto requiere 3 pasos:
--   - Eliminar la PK clustered actual (en id)
--   - Recrearla como NONCLUSTERED
--   - Crear el nuevo índice CLUSTERED en fecha_emision

-- Posteriormente se realiza la misma consulta con índice clustered en fecha_emision, 
-- permitiendo acceso directo al rango de fechas.
-- CLUSTERED INDEX SEEK va directo al rango de fechas
-- Lee solo las páginas necesarias (las de los últimos 7 días)
-- Resultado esperado:
--   Tiempo: BAJO
--   I/O: Reducción del 70-95% vs Prueba 1
---------------------------------------------------------------------------
---------------------------------------------------------------------------
			-- CREANDO ÍNDICE CLUSTERED EN fecha_emision' --
---------------------------------------------------------------------------

-- Paso 1: Eliminar constraint de PK clustered
ALTER TABLE auditoria_votos 
DROP CONSTRAINT PK_auditoria_votos;
GO

-- Paso 2: Recrear PK como NONCLUSTERED
ALTER TABLE auditoria_votos 
ADD CONSTRAINT PK_auditoria_votos PRIMARY KEY NONCLUSTERED (id);
GO

-- Paso 3: Crear índice CLUSTERED en fecha_emision
CREATE CLUSTERED INDEX IX_auditoria_votos_fecha
ON auditoria_votos(fecha_emision DESC);
GO


---------------------------------------------------------------------------
--      PRUEBA 2 - CONSULTA CON ÍNDICE CLUSTERED
---------------------------------------------------------------------------

DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- MISMA CONSULTA
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
--   -Tiempo de CPU: 204 ms
--   -Tiempo transcurrido: 1643 ms (mejoró)
--   -Lecturas lógicas: 584 páginas (empeoró)
-- No se obtuvieron mejoras drasticas ya que Los últimos 7 días representan 
-- un rango muy grande en los datos cargados. SQL Server está leyendo casi 
-- la misma cantidad de datos
---------------------------------------------------------------------------