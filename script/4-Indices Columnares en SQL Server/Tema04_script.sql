CREATE DATABASE proyecto_elecciones;
GO

USE proyecto_elecciones
GO

-- ============================================================================
-- PROYECTO: Sistema de Voto Electrónico Estudiantil
-- BASE DE DATOS: proyecto_elecciones
-- TEMA: Indices columnares en SQL Server (Nicolas)
-- ============================================================================


-- ============================================================================
-- PARTE 1: APLICACIÓN EN EL SISTEMA DE VOTACIÓN
-- ============================================================================

PRINT '-----------------------------------------------------------'
PRINT '1. TABLAS CANDIDATAS PARA ÍNDICES COLUMNARES'
PRINT '-----------------------------------------------------------'
PRINT ''
PRINT 'En nuestro sistema de voto electrónico, las tablas ideales son:'
PRINT ''
PRINT ' resultado_eleccion:'
PRINT '  - Contiene totales finales por elección'
PRINT '  - Se escribe UNA VEZ al finalizar el escrutinio'
PRINT '  - Se consulta MUCHAS VECES para reportes'
PRINT '  - Columnas: eleccion_id, lista_id, resultado'
PRINT ''
PRINT ' escrutinio_mesa:'
PRINT '  - Detalle de votos por mesa y lista'
PRINT '  - Se escribe al finalizar cada mesa'
PRINT '  - Ideal para análisis agregados (SUM, COUNT, AVG)'
PRINT '  - Columnas: mesa_votacion_id, lista_id, cantidad_votos'
PRINT ''
PRINT 'NO se recomienda en:'
PRINT '  - Tabla voto (escritura continua durante votación activa)'
PRINT '  - Tablas con actualizaciones frecuentes'
PRINT ''

-- ============================================================================
-- PARTE 2: ANÁLISIS DEL ESTADO ACTUAL (SIN ÍNDICE COLUMNAR)
-- ============================================================================

PRINT '-----------------------------------------------------------'
PRINT '2. MEDICIÓN DE RENDIMIENTO SIN ÍNDICE COLUMNAR'
PRINT '-----------------------------------------------------------'
PRINT ''

-- Contar registros actuales en las tablas principales
DECLARE @total_votos INT = (SELECT COUNT(*) FROM voto);
DECLARE @total_escrutinio INT = (SELECT COUNT(*) FROM escrutinio_mesa);
DECLARE @total_resultado INT = (SELECT COUNT(*) FROM resultado_eleccion);

PRINT 'Estado actual de la base de datos:'
PRINT '  - Votos registrados: ' + CAST(@total_votos AS VARCHAR)
PRINT '  - Registros en escrutinio_mesa: ' + CAST(@total_escrutinio AS VARCHAR)
PRINT '  - Registros en resultado_eleccion: ' + CAST(@total_resultado AS VARCHAR)
PRINT ''

IF @total_escrutinio = 0
BEGIN
    PRINT 'No hay datos en escrutinio_mesa'
    PRINT ''
END

-- Vaciar caché de datos y planes de ejecución para prueba limpia
DBCC DROPCLEANBUFFERS; -- Limpia el buffer pool de datos
DBCC FREEPROCCACHE;    -- Limpia planes de ejecución en caché
GO

-- Activar medición de tiempos de CPU y lecturas de disco
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

PRINT ''
PRINT '════════════════════════════════════════════════════════════════════'
PRINT 'CONSULTA 1: Ranking de listas por total de votos sin indice columnar'
PRINT '════════════════════════════════════════════════════════════════════'

-- Marca de inicio para calcular tiempo transcurrido
DECLARE @inicio1 DATETIME2 = SYSDATETIME();

SELECT 
    p.nombre_partido,
    l.lista_id,
    SUM(em.cantidad_votos) AS total_votos,
    -- Calcular porcentaje sobre el total general
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
PRINT 'Tiempo sin índice columnar: ' + CAST(@tiempo1_sin/1000.0 AS VARCHAR(20)) + ' ms'
PRINT ''

-------------------------------------------------

PRINT '═══════════════════════════════════════════════════════════'
PRINT 'CONSULTA 2: Análisis de votos por mesa, Sin indice columnar'
PRINT '═══════════════════════════════════════════════════════════'

-- Limpiar caché nuevamente para cada consulta
DBCC DROPCLEANBUFFERS;
DECLARE @inicio2 DATETIME2 = SYSDATETIME();

SELECT 
    em.mesa_votacion_id,
    COUNT(DISTINCT em.lista_id) AS listas_participantes,
    SUM(em.cantidad_votos) AS total_votos_mesa,
    AVG(em.cantidad_votos) AS promedio_por_lista,  -- Promedio de votos por lista
    MAX(em.cantidad_votos) AS votos_lista_ganadora -- Lista más votada
FROM escrutinio_mesa em
GROUP BY em.mesa_votacion_id
ORDER BY total_votos_mesa DESC;

DECLARE @fin2 DATETIME2 = SYSDATETIME();
DECLARE @tiempo2_sin INT = DATEDIFF(MICROSECOND, @inicio2, @fin2);

PRINT ''
PRINT 'Tiempo sin índice columnar: ' + CAST(@tiempo2_sin/1000.0 AS VARCHAR(20)) + ' ms'
PRINT ''

-------------------------------------------------

PRINT '═══════════════════════════════════════════════════════════════════════'
PRINT 'CONSULTA 3: Resultados finales con datos completos, Sin indice Columnar'
PRINT '═══════════════════════════════════════════════════════════════════════'

DBCC DROPCLEANBUFFERS;
DECLARE @inicio3 DATETIME2 = SYSDATETIME();

SELECT 
    re.eleccion_id,
    e.año,
    p.nombre_partido,
    re.resultado AS votos_totales,
    -- Porcentaje calculado con función de ventana OVER
    CAST(re.resultado * 100.0 / SUM(re.resultado) OVER (PARTITION BY re.eleccion_id) 
         AS DECIMAL(5,2)) AS porcentaje,
    -- Ranking dentro de cada elección
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

-- Sumar todos los tiempos para obtener total
DECLARE @tiempo_total_sin INT = @tiempo1_sin + @tiempo2_sin + @tiempo3_sin;

PRINT '-----------------------------------------------------------'
PRINT 'RESUMEN - SIN ÍNDICE COLUMNAR:'
PRINT '  Consulta 1: ' + CAST(@tiempo1_sin/1000.0 AS VARCHAR(20)) + ' ms'
PRINT '  Consulta 2: ' + CAST(@tiempo2_sin/1000.0 AS VARCHAR(20)) + ' ms'
PRINT '  Consulta 3: ' + CAST(@tiempo3_sin/1000.0 AS VARCHAR(20)) + ' ms'
PRINT '  TOTAL:      ' + CAST(@tiempo_total_sin/1000.0 AS VARCHAR(20)) + ' ms'
PRINT '-----------------------------------------------------------'
PRINT ''

-- ============================================================================
-- PARTE 3: CREAR ÍNDICES COLUMNARES
-- ============================================================================

PRINT '-----------------------------------------------------------'
PRINT '4. CREACIÓN DE ÍNDICES COLUMNARES'
PRINT '-----------------------------------------------------------'
PRINT ''

-- Verificar si ya existe el índice y eliminarlo
IF EXISTS (SELECT 1 FROM sys.indexes 
           WHERE name = 'idx_cs_escrutinio_mesa' 
           AND object_id = OBJECT_ID('escrutinio_mesa'))
BEGIN
    DROP INDEX idx_cs_escrutinio_mesa ON escrutinio_mesa;
    PRINT 'Indice anterior eliminado en escrutinio_mesa'
END

-- Crear índice NONCLUSTERED COLUMNSTORE (almacena datos por columna)
CREATE NONCLUSTERED COLUMNSTORE INDEX idx_cs_escrutinio_mesa
ON escrutinio_mesa (
    mesa_votacion_id,
    lista_id,
    cantidad_votos  -- Columnas más consultadas en agregaciones
);

PRINT 'Indice columnar creado en escrutinio_mesa'
PRINT ''

-- Mismo proceso para tabla resultado_eleccion
IF EXISTS (SELECT 1 FROM sys.indexes 
           WHERE name = 'idx_cs_resultado_eleccion' 
           AND object_id = OBJECT_ID('resultado_eleccion'))
BEGIN
    DROP INDEX idx_cs_resultado_eleccion ON resultado_eleccion;
    PRINT 'Indice anterior eliminado en resultado_eleccion'
END

CREATE NONCLUSTERED COLUMNSTORE INDEX idx_cs_resultado_eleccion
ON resultado_eleccion (
    eleccion_id,
    lista_id,
    resultado       -- Columna con totales de votos
);

PRINT 'Indice columnar creado en resultado_eleccion'
PRINT ''

-- Consultar metadata del sistema para ver info de índices creados
PRINT 'Información de índices creados:'
SELECT 
    t.name AS tabla,
    i.name AS nombre_indice,
    i.type_desc AS tipo,
    p.rows AS filas,
    -- Calcular tamaño en MB (páginas * 8KB / 1024)
    CAST(SUM(a.used_pages) * 8 / 1024.0 AS DECIMAL(10,2)) AS tamaño_mb
FROM sys.tables t
    INNER JOIN sys.indexes i ON t.object_id = i.object_id
    INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
    INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.name IN ('escrutinio_mesa', 'resultado_eleccion')
  AND i.type_desc LIKE '%COLUMNSTORE%'  -- Filtrar solo índices columnares
GROUP BY t.name, i.name, i.type_desc, p.rows;

PRINT ''

-- ============================================================================
-- PARTE 4: MEDICIÓN CON ÍNDICE COLUMNAR
-- ============================================================================

PRINT '-----------------------------------------------------------'
PRINT '5. MEDICIÓN DE RENDIMIENTO CON ÍNDICE COLUMNAR'
PRINT '-----------------------------------------------------------'
PRINT ''

-- Limpiar caché para comparación justa
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

PRINT ''
PRINT '═════════════════════════════════════════════════════════════════════'
PRINT 'CONSULTA 1: Ranking de listas por total de votos, CON indice columnar'
PRINT '═════════════════════════════════════════════════════════════════════'

DECLARE @inicio1_con DATETIME2 = SYSDATETIME();

-- Misma consulta que antes, ahora usará el índice columnar automáticamente
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

-- Intentar recuperar tiempo anterior (puede fallar por batch separado)
DECLARE @tiempo1_sin INT;
SELECT @tiempo1_sin = CAST(value AS INT) FROM sys.extended_properties 
WHERE name = 'tiempo1_sin';

PRINT ''
PRINT 'Tiempo con índice columnar: ' + CAST(@tiempo1_con/1000.0 AS VARCHAR(20)) + ' ms'
PRINT ''

-------------------------------------------------

PRINT '═══════════════════════════════════════════════════════════'
PRINT 'CONSULTA 2: Análisis de votos por mesa, CON indice columnar'
PRINT '═══════════════════════════════════════════════════════════'

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

-- -----------------------------------------------

PRINT '══════════════════════════════════════════════════════════════════════'
PRINT 'CONSULTA 3: Resultados finales con datos completos,CON índice columnar'
PRINT '══════════════════════════════════════════════════════════════════════'

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


-- ============================================================================
-- PARTE 5: CONCLUSIONES FINALES
-- ============================================================================

PRINT '═══════════════════════════════════════════════════════════'
PRINT '5. CONCLUSIONES'
PRINT '═══════════════════════════════════════════════════════════'
PRINT ''
PRINT 'VENTAJAS DE LOS ÍNDICES COLUMNARES:'
PRINT ''
PRINT '✓ Mayor velocidad en consultas analíticas'
PRINT '  Al almacenar datos por columnas, el motor solo lee las columnas'
PRINT '  necesarias, evitando información irrelevante.'
PRINT ''
PRINT '✓ Compresión de datos más eficiente'
PRINT '  Los valores en una columna suelen ser similares o repetitivos,'
PRINT '  lo que permite mejor compresión y menor uso de memoria.'
PRINT ''
PRINT '✓ Mejor aprovechamiento de recursos'
PRINT '  Alta tasa de compresión facilita la carga en memoria y mejora'
PRINT '  el desempeño general durante consultas.'
PRINT ''
PRINT '✓ Procesamiento paralelo optimizado'
PRINT '  SQL Server puede ejecutar consultas sobre diferentes columnas'
PRINT '  simultáneamente, aprovechando múltiples núcleos del procesador.'
PRINT ''
PRINT 'APLICACIÓN EN SISTEMA DE VOTO ELECTRÓNICO:'
PRINT ''
PRINT 'Tablas recomendadas:'
PRINT '  - resultado_eleccion (totales finales)'
PRINT '  - escrutinio_mesa (detalle por mesa)'
PRINT ''
PRINT 'NO recomendado en:'
PRINT '  - Tabla voto (escritura continua durante votación)'
PRINT '  - Tablas con actualizaciones frecuentes'
PRINT '  - Tablas pequeñas de configuración'
PRINT ''
PRINT 'CONTEXTO OLTP vs OLAP:'
PRINT ''
PRINT '  OLTP (Transaccional): Registrar cada voto individual'
PRINT '  → Usar índices B-tree tradicionales'
PRINT ''
PRINT '  OLAP (Analítico): Generar reportes y estadísticas'
PRINT '  → Usar índices columnares'
PRINT ''
PRINT 'ESTRATEGIA HÍBRIDA RECOMENDADA:'
PRINT ''
PRINT '  1. Durante votación: Índices tradicionales en tabla voto'
PRINT '  2. Post-votación: Crear índices columnares en escrutinio'
PRINT '  3. Análisis histórico: Índices columnares para todas las elecciones'
PRINT ''
GO