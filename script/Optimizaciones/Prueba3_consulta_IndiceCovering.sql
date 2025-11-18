---------------------------------------------------------------------------
-- Para realizar la Prueba 3 (CONSULTA CON ÍNDICE COVERING)
-- 1. Se procede a quitar el índice clustered para probar la tercera opción (índice covering)
-- 2. Creamos el indice NONCLUSTERED. Este es el índice más inteligente porque:
--   - Mantiene la PK como clustered (en id)
--   - Crea un índice separado en fecha_emision
--   - Incluye las columnas mesa, lista, descripcion
--   - Evita el "Key Lookup" (no necesita ir a la tabla base)
-- Luego procedemos a ejecutar la misma consulta pero ahora con el índice covering. 
-- Se espera que sea el más eficiente, con lecturas similares o mejores que la Prueba 2.B 
---------------------------------------------------------------------------

---------------------------------------------------------------------------
			-- 1. ELIMINANDO ÍNDICE CLUSTERED --
---------------------------------------------------------------------------


-- Eliminar índice clustered en fecha_emision
DROP INDEX IX_auditoria_votos_fecha ON auditoria_votos;
GO

-- Restaurar PK como clustered (configuración original)
ALTER TABLE auditoria_votos 
DROP CONSTRAINT PK_auditoria_votos;
GO

ALTER TABLE auditoria_votos 
ADD CONSTRAINT PK_auditoria_votos PRIMARY KEY CLUSTERED (id);
GO

---------------------------------------------------------------------------
           -- 2. CREANDO ÍNDICE NONCLUSTERED CON INCLUDE (COVERING)
---------------------------------------------------------------------------


CREATE NONCLUSTERED INDEX IX_auditoria_votos_fecha_COVERING
ON auditoria_votos(fecha_emision DESC)
INCLUDE (mesa, lista, descripcion);
GO

PRINT 'Índice covering creado exitosamente.';
PRINT '';
PRINT 'Características:';
PRINT '  - Clave del índice: fecha_emision (DESC)';
PRINT '  - Columnas incluidas: mesa, lista, descripcion';
PRINT '  - Beneficio: Evita Key Lookup (acceso a tabla base)';
PRINT '';


---------------------------------------------------------------------------
          -- PRUEBA 3: CONSULTA CON ÍNDICE NONCLUSTERED + INCLUDE';
---------------------------------------------------------------------------

-- Limpiar caché
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;


-- MISMA CONSULTA (1 hora para comparar con Prueba 2.B)
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
--   -Tiempo transcurrido: 258 ms 
--   -Lecturas lógicas: 17 páginas 

-- Con estos analisis podemos concluir que el Indice Covering es mejor porque:
--    - Tenemos menos lecturas: 17 vs 20 páginas
--    - Sin Key Lookup: Todo se resuelve desde el índice
--    - Mantiene flexibilidad: La PK sigue siendo clustered en id
--    - Escalable: es posible crear más índices nonclustered de ser necesario.
---------------------------------------------------------------------------