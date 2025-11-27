-- ============================================================================
-- PROYECTO: Sistema de Voto Electrónico Estudiantil
-- BASE DE DATOS: proyecto_elecciones
-- TEMA: Índices Columnares en SQL Server (Nicolás)
-- ============================================================================
USE proyecto_elecciones
GO

-- ============================================================================
-- PARTE 1: VERIFICACIÓN DE DATOS
-- ============================================================================

PRINT '-----------------------------------------------------------'
PRINT '1. VERIFICACIÓN DE DATOS ACTUALES'
PRINT '-----------------------------------------------------------'
PRINT ''

-- Contar registros en tablas principales
DECLARE @total_estudiantes INT = (SELECT COUNT(*) FROM estudiante);
DECLARE @total_votos INT = (SELECT COUNT(*) FROM voto);
DECLARE @total_escrutinio INT = (SELECT COUNT(*) FROM escrutinio_mesa);
DECLARE @total_resultado INT = (SELECT COUNT(*) FROM resultado_eleccion);

PRINT 'Estado de la base de datos:'
PRINT '  Estudiantes registrados: ' + CAST(@total_estudiantes AS VARCHAR(30))
PRINT '  Votos emitidos: ' + CAST(@total_votos AS VARCHAR(30))
PRINT '  Registros en escrutinio_mesa: ' + CAST(@total_escrutinio AS VARCHAR(30))
PRINT '  Registros en resultado_eleccion: ' + CAST(@total_resultado AS VARCHAR(30))
PRINT ''

-- Validar que hay datos para las pruebas
IF @total_escrutinio = 0 OR @total_resultado = 0
BEGIN
    PRINT ' No hay datos suficientes para las pruebas'
    PRINT ''
END
ELSE
BEGIN
    PRINT 'Datos disponibles para pruebas de rendimiento'
    PRINT ''
END

-- ============================================================================
-- PARTE 2: MEDICIÓN SIN ÍNDICE COLUMNAR (BASELINE)
-- ============================================================================

PRINT '═══════════════════════════════════════════════════════════'
PRINT '2. MEDICIÓN DE RENDIMIENTO - SIN ÍNDICE COLUMNAR'
PRINT '═══════════════════════════════════════════════════════════'
PRINT ''

-- Vaciar cache para medicion limpia
DBCC DROPCLEANBUFFERS;  -- Limpia buffer pool de datos en memoria
DBCC FREEPROCCACHE;     -- Limpia planes de ejecución cacheados
GO

-- Activar estadísticas detalladas
SET STATISTICS TIME ON;  -- Muestra tiempo de CPU y elapsed
SET STATISTICS IO ON;    -- Muestra lecturas lógicas y físicas

PRINT ''
PRINT '────────────────────────────────────────────────────────────────────'
PRINT 'CONSULTA 1: Ranking de listas por total de votos SIN índice columnar'
PRINT '────────────────────────────────────────────────────────────────────'

-- Capturar tiempo inicial
DECLARE @inicio1 DATETIME2 = SYSDATETIME();

SELECT 
    p.nombre_partido,
    l.lista_id,
    SUM(em.cantidad_votos) AS total_votos,
    -- Calcular porcentaje sobre total general
    CAST(SUM(em.cantidad_votos) * 100.0 / 
         (SELECT SUM(cantidad_votos) FROM escrutinio_mesa) 
         AS DECIMAL(5,2)) AS porcentaje
FROM escrutinio_mesa em
    INNER JOIN lista l ON em.lista_id = l.lista_id
    INNER JOIN partido p ON l.partido_id = p.partido_id
GROUP BY p.nombre_partido, l.lista_id
ORDER BY total_votos DESC;

-- Calcular tiempo transcurrido en microsegundos
DECLARE @fin1 DATETIME2 = SYSDATETIME();
DECLARE @tiempo1_sin INT = DATEDIFF(MICROSECOND, @inicio1, @fin1);

PRINT ''
PRINT ' Tiempo sin índice columnar: ' + CAST(@tiempo1_sin/1000.0 AS VARCHAR(20)) + ' ms'
PRINT ''

-- ---------------------------------------------------------------

PRINT '──────────────────────────────────────────────────────────────────'
PRINT 'CONSULTA 2: Análisis de participación por mesa,SIN índice columnar'
PRINT '──────────────────────────────────────────────────────────────────'

-- Limpiar caché para cada consulta
DBCC DROPCLEANBUFFERS;
DECLARE @inicio2 DATETIME2 = SYSDATETIME();

SELECT 
    em.mesa_votacion_id,
    COUNT(DISTINCT em.lista_id) AS listas_participantes,
    SUM(em.cantidad_votos) AS total_votos_mesa,
    AVG(em.cantidad_votos) AS promedio_por_lista,   -- Promedio de votos
    MAX(em.cantidad_votos) AS votos_lista_ganadora  -- Lista más votada
FROM escrutinio_mesa em
GROUP BY em.mesa_votacion_id
ORDER BY total_votos_mesa DESC;

DECLARE @fin2 DATETIME2 = SYSDATETIME();
DECLARE @tiempo2_sin INT = DATEDIFF(MICROSECOND, @inicio2, @fin2);

PRINT ''
PRINT ' Tiempo sin índice columnar: ' + CAST(@tiempo2_sin/1000.0 AS VARCHAR(20)) + ' ms'
PRINT ''

-- ---------------------------------------------------------------

PRINT '──────────────────────────────────────────────────────────────'
PRINT 'CONSULTA 3: Resultados finales con ranking SIN índice columnar'
PRINT '──────────────────────────────────────────────────────────────'

DBCC DROPCLEANBUFFERS;
DECLARE @inicio3 DATETIME2 = SYSDATETIME();

SELECT 
    re.eleccion_id,
    e.año,
    p.nombre_partido,
    re.resultado AS votos_totales,
    -- Porcentaje con función de ventana OVER
    CAST(re.resultado * 100.0 / SUM(re.resultado) OVER (PARTITION BY re.eleccion_id) 
         AS DECIMAL(5,2)) AS porcentaje,
    -- Ranking por elección
    RANK() OVER (PARTITION BY re.eleccion_id ORDER BY re.resultado DESC) AS ranking
FROM resultado_eleccion re
    INNER JOIN eleccion e ON re.eleccion_id = e.eleccion_id
    INNER JOIN lista l ON re.lista_id = l.lista_id
    INNER JOIN partido p ON l.partido_id = p.partido_id
ORDER BY e.año DESC, ranking;

DECLARE @fin3 DATETIME2 = SYSDATETIME();
DECLARE @tiempo3_sin INT = DATEDIFF(MICROSECOND, @inicio3, @fin3);

PRINT ''
PRINT 'Tiempo sin índice columnar: ' + CAST(@tiempo3_sin/1000.0 AS VARCHAR(20)) + ' ms'
PRINT ''

-- Desactivar estadísticas
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

-- Calcular total acumulado
DECLARE @tiempo_total_sin INT = @tiempo1_sin + @tiempo2_sin + @tiempo3_sin;

PRINT '═══════════════════════════════════════════════════════════'
PRINT 'RESUMEN - SIN ÍNDICE COLUMNAR:'
PRINT '  Consulta 1 (Ranking):       ' + RIGHT('        ' + CAST(@tiempo1_sin/1000.0 AS VARCHAR(30)), 8) + ' ms'
PRINT '  Consulta 2 (Por mesa):      ' + RIGHT('        ' + CAST(@tiempo2_sin/1000.0 AS VARCHAR(30)), 8) + ' ms'
PRINT '  Consulta 3 (Resultados):    ' + RIGHT('        ' + CAST(@tiempo3_sin/1000.0 AS VARCHAR(30)), 8) + ' ms'
PRINT '  ──────────────────────────────────────'
PRINT '  TOTAL:                      ' + RIGHT('        ' + CAST(@tiempo_total_sin/1000.0 AS VARCHAR(30)), 8) + ' ms'
PRINT '═══════════════════════════════════════════════════════════'
PRINT ''

-- ============================================================================
-- PARTE 3: CREACIÓN DE ÍNDICES COLUMNARES
-- ============================================================================

PRINT '═══════════════════════════════════════════════════════════'
PRINT '3. CREACIÓN DE ÍNDICES COLUMNARES'
PRINT '═══════════════════════════════════════════════════════════'
PRINT ''

-- Eliminar índice anterior si existe
IF EXISTS (SELECT 1 FROM sys.indexes 
           WHERE name = 'idx_cs_escrutinio_mesa' 
           AND object_id = OBJECT_ID('escrutinio_mesa'))
BEGIN
    DROP INDEX idx_cs_escrutinio_mesa ON escrutinio_mesa;
    PRINT 'Índice anterior eliminado en escrutinio_mesa'
END

-- Crear índice solo si no existe
IF NOT EXISTS (SELECT 1 FROM sys.indexes 
               WHERE name = 'idx_cs_escrutinio_mesa' 
               AND object_id = OBJECT_ID('escrutinio_mesa'))
BEGIN
    CREATE NONCLUSTERED COLUMNSTORE INDEX idx_cs_escrutinio_mesa
    ON escrutinio_mesa (
        mesa_votacion_id,   -- ID de mesa (filtros frecuentes)
        lista_id,           -- ID de lista (agrupaciones)
        cantidad_votos      -- Cantidad para agregaciones (SUM, AVG)
    );
    PRINT 'Índice columnar creado en escrutinio_mesa'
END

-- Mismo proceso para resultado_eleccion
IF EXISTS (SELECT 1 FROM sys.indexes 
           WHERE name = 'idx_cs_resultado_eleccion' 
           AND object_id = OBJECT_ID('resultado_eleccion'))
BEGIN
    DROP INDEX idx_cs_resultado_eleccion ON resultado_eleccion;
    PRINT 'Índice anterior eliminado en resultado_eleccion'
END

-- Crear índice solo si no existe
IF NOT EXISTS (SELECT 1 FROM sys.indexes 
               WHERE name = 'idx_cs_resultado_eleccion' 
               AND object_id = OBJECT_ID('resultado_eleccion'))
BEGIN
    CREATE NONCLUSTERED COLUMNSTORE INDEX idx_cs_resultado_eleccion
    ON resultado_eleccion (
        eleccion_id,    -- ID de elección (filtros y agrupaciones)
        lista_id,       -- ID de lista
        resultado       -- Total de votos (agregaciones)
    );
    PRINT 'Índice columnar creado en resultado_eleccion'
END

-- Consultar metadata para verificar índices creados
PRINT '─────────────────────────────────────────────────────────────'
PRINT 'Información de índices columnares creados:'
PRINT '─────────────────────────────────────────────────────────────'

SELECT 
    t.name AS tabla,
    i.name AS nombre_indice,
    i.type_desc AS tipo,
    p.rows AS filas,
    -- Tamaño en MB: (páginas usadas * 8KB) / 1024
    CAST(SUM(a.used_pages) * 8 / 1024.0 AS DECIMAL(10,2)) AS tamaño_mb
FROM sys.tables t
    INNER JOIN sys.indexes i ON t.object_id = i.object_id
    INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
    INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.name IN ('escrutinio_mesa', 'resultado_eleccion')
  AND i.type_desc LIKE '%COLUMNSTORE%'  -- Solo índices columnares
GROUP BY t.name, i.name, i.type_desc, p.rows;

PRINT ''

-- ============================================================================
-- PARTE 4: MEDICIÓN CON ÍNDICE COLUMNAR
-- ============================================================================

PRINT '═══════════════════════════════════════════════════════════'
PRINT '4. MEDICIÓN DE RENDIMIENTO - CON ÍNDICE COLUMNAR'
PRINT '═══════════════════════════════════════════════════════════'
PRINT ''

-- Limpiar caché para comparación justa
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

PRINT ''
PRINT '─────────────────────────────────────────────────────────────'
PRINT 'CONSULTA 1: Ranking de listas por total de votos CON índice columnar'
PRINT '─────────────────────────────────────────────────────────────'

DECLARE @inicio1_con DATETIME2 = SYSDATETIME();

-- Misma consulta, ahora usa índice columnar automáticamente
SELECT 
    p.nombre_partido,
    l.lista_id,
    SUM(em.cantidad_votos) AS total_votos,
    CAST(SUM(em.cantidad_votos) * 100.0 / 
         (SELECT SUM(cantidad_votos) FROM escrutinio_mesa) 
         AS DECIMAL(5,2)) AS porcentaje
FROM escrutinio_mesa em
    INNER JOIN lista l ON em.lista_id = l.lista_id
    INNER JOIN partido p ON l.partido_id = p.partido_id
GROUP BY p.nombre_partido, l.lista_id
ORDER BY total_votos DESC;

DECLARE @fin1_con DATETIME2 = SYSDATETIME();
DECLARE @tiempo1_con INT = DATEDIFF(MICROSECOND, @inicio1_con, @fin1_con);

PRINT ''
PRINT 'Tiempo con índice columnar: ' + CAST(@tiempo1_con/1000.0 AS VARCHAR(20)) + ' ms'
PRINT ''

-- ---------------------------------------------------------------

PRINT '──────────────────────────────────────────────────────────────────'
PRINT 'CONSULTA 2: Análisis de participación por mesa CON índice columnar'
PRINT '──────────────────────────────────────────────────────────────────'

DBCC DROPCLEANBUFFERS;
DECLARE @inicio2_con DATETIME2 = SYSDATETIME();

SELECT 
    em.mesa_votacion_id,
    COUNT(DISTINCT em.lista_id) AS listas_participantes,
    SUM(em.cantidad_votos) AS total_votos_mesa,
    AVG(em.cantidad_votos) AS promedio_por_lista,
    MAX(em.cantidad_votos) AS votos_lista_ganadora
FROM escrutinio_mesa em
GROUP BY em.mesa_votacion_id
ORDER BY total_votos_mesa DESC;

DECLARE @fin2_con DATETIME2 = SYSDATETIME();
DECLARE @tiempo2_con INT = DATEDIFF(MICROSECOND, @inicio2_con, @fin2_con);

PRINT ''
PRINT 'Tiempo con índice columnar: ' + CAST(@tiempo2_con/1000.0 AS VARCHAR(20)) + ' ms'
PRINT ''

-- ---------------------------------------------------------------

PRINT '──────────────────────────────────────────────────────────────'
PRINT 'CONSULTA 3: Resultados finales con ranking CON índice columnar'
PRINT '──────────────────────────────────────────────────────────────'

DBCC DROPCLEANBUFFERS;
DECLARE @inicio3_con DATETIME2 = SYSDATETIME();

SELECT 
    re.eleccion_id,
    e.año,
    p.nombre_partido,
    re.resultado AS votos_totales,
    CAST(re.resultado * 100.0 / SUM(re.resultado) OVER (PARTITION BY re.eleccion_id) 
         AS DECIMAL(5,2)) AS porcentaje,
    RANK() OVER (PARTITION BY re.eleccion_id ORDER BY re.resultado DESC) AS ranking
FROM resultado_eleccion re
    INNER JOIN eleccion e ON re.eleccion_id = e.eleccion_id
    INNER JOIN lista l ON re.lista_id = l.lista_id
    INNER JOIN partido p ON l.partido_id = p.partido_id
ORDER BY e.año DESC, ranking;

DECLARE @fin3_con DATETIME2 = SYSDATETIME();
DECLARE @tiempo3_con INT = DATEDIFF(MICROSECOND, @inicio3_con, @fin3_con);

PRINT ''
PRINT 'Tiempo con índice columnar: ' + CAST(@tiempo3_con/1000.0 AS VARCHAR(20)) + ' ms'
PRINT ''

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

-- Calcular total con índices
DECLARE @tiempo_total_con INT = @tiempo1_con + @tiempo2_con + @tiempo3_con;

PRINT '═══════════════════════════════════════════════════════════'
PRINT 'RESUMEN - CON ÍNDICE COLUMNAR:'
PRINT '  Consulta 1 (Ranking):       ' + RIGHT('        ' + CAST(@tiempo1_con/1000.0 AS VARCHAR(30)), 8) + ' ms'
PRINT '  Consulta 2 (Por mesa):      ' + RIGHT('        ' + CAST(@tiempo2_con/1000.0 AS VARCHAR(30)), 8) + ' ms'
PRINT '  Consulta 3 (Resultados):    ' + RIGHT('        ' + CAST(@tiempo3_con/1000.0 AS VARCHAR(30)), 8) + ' ms'
PRINT '  ──────────────────────────────────────'
PRINT '  TOTAL:                      ' + RIGHT('        ' + CAST(@tiempo_total_con/1000.0 AS VARCHAR(30)), 8) + ' ms'
PRINT '═══════════════════════════════════════════════════════════'
PRINT ''

-- ============================================================================
-- PARTE 5: COMPARACIÓN Y ANÁLISIS DE RESULTADOS
-- ============================================================================

PRINT '═══════════════════════════════════════════════════════════'
PRINT '5. COMPARACIÓN DE RENDIMIENTO'
PRINT '═══════════════════════════════════════════════════════════'
PRINT ''
PRINT 'Las mejoras pueden variar según el volumen de datos.'
PRINT 'Con conjuntos de datos más grandes (millones de registros),'
PRINT 'las diferencias serán mucho más significativas.'
PRINT ''
PRINT '─────────────────────────────────────────────────────────────'
PRINT 'Análisis por consulta:'
PRINT '─────────────────────────────────────────────────────────────'
PRINT 'Los índices columnares optimizan especialmente:'
PRINT '  • Agregaciones (SUM, COUNT, AVG)'
PRINT '  • Escaneos de columnas específicas'
PRINT '  • Consultas con GROUP BY'
PRINT '  • Compresión de datos repetitivos'
PRINT ''

-- ============================================================================
-- PARTE 6: CONCLUSIONES Y RECOMENDACIONES
-- ============================================================================

PRINT '═══════════════════════════════════════════════════════════'
PRINT '6. CONCLUSIONES'
PRINT '═══════════════════════════════════════════════════════════'
PRINT ''
PRINT ' VENTAJAS DE LOS ÍNDICES COLUMNARES:'
PRINT ''
PRINT '  1. Mayor velocidad en consultas analíticas'
PRINT '     Al leer solo columnas necesarias, evita I/O innecesario'
PRINT ''
PRINT '  2. Compresión eficiente de datos'
PRINT '     Valores similares en columnas se comprimen mejor (~10x)'
PRINT ''
PRINT '  3. Mejor uso de memoria'
PRINT '     Menos datos en memoria = más eficiencia'
PRINT ''
PRINT ''
PRINT 'APLICACIÓN EN SISTEMA DE VOTO ELECTRÓNICO:'
PRINT ''
PRINT '  Recomendado para:'
PRINT '    • resultado_eleccion (totales consolidados)'
PRINT '    • escrutinio_mesa (análisis por mesa)'
PRINT '    • Datos históricos de elecciones'
PRINT ''
PRINT '  NO recomendado para: tablas pequeñas o de con actualizacion constante'
PRINT ''
PRINT '═══════════════════════════════════════════════════════════'
PRINT '═══════════════════════════════════════════════════════════'

GO




