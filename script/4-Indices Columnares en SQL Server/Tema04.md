# Índices Columnares en SQL Server

## Objetivos de Aprendizaje
- Comprender los conceptos y aplicaciones de los índices columnares.
- Evaluar la mejora de rendimiento en consultas al usar índices columnares en comparación con índices tradicionales.

## Criterios de Evaluación
- Implementación correcta del índice columnar y comparación de resultados con índices tradicionales.
- Documentación detallada del rendimiento y tiempos de consulta.
- Claridad en las conclusiones sobre la mejora de rendimiento.

## Tareas
- Crear una nueva tabla, tomando como modelo la tabla de mayor ocurrencia del modelo (tabla origen), y renombrarla (tabla nueva).
- Realizar una carga masiva de por lo menos 1 millón de registros sobre la tabla recién creada. Se pueden repetir los registros ya existentes. Hacerlo con un script para poder compartirlo.
- Definir un índice columnar sobre la nueva tabla.
- Ejecutar una consulta sobre tabla origen y la tabla nueva, evaluar los tiempos de respuestas entre ambas tablas (con índice columnar y sin el mismo).
- Expresar las conclusiones en base a las pruebas realizadas.

## Introducción a los Índices Columnares

En el contexto actual de manejo y análisis de grandes volúmenes de información, la eficiencia en el acceso y procesamiento de datos constituye un factor clave para el rendimiento de los 
sistemas de gestión de base de datos. En este sentido se incorporan los índices columnares como una tecnología orientada a optimizar las consultas analíticas y las operaciones de lectura 
sobre los conjuntos de datos extensos.

A diferencia de los índices tradicionales basados en filas, los índices columnares almacenan los datos organizados por columnas, lo que permite una mayor compresión, una reducción 
significativa en el uso de memoria y un mejor aprovechamiento de los recursos del sistema.

## Ventajas de los Índices Columnares frente a los Índices Tradicionales

El uso de los índices columnares en lugar de los tradicionales, ofrece una serie de ventajas significativas, especialmente en el caso propuesto del sistema de voto electrónico ya que se 
requieren realizar consultas analíticas o de lectura intensiva.

### 1. Mayor velocidad en las consultas analíticas
Al almacenar los datos por columnas, el motor de base de datos puede leer únicamente las columnas necesarias para una consulta específica, evitando acceder a información irrelevante.
Lo que reduce el tiempo de lectura y mejora el rendimiento.

### 2. Compresión de datos más eficiente
Permiten aplicar técnicas de compresión más efectivas, ya que los valores dentro de una misma columna suelen ser similares o repetitivos. Esto disminuye el espacio ocupado en disco y 
en memoria, optimizando el uso de recursos del sistema.

### 3. Mejor aprovechamiento de la memoria y del almacenamiento
Gracias a la alta tasa de compresión, los datos pueden almacenarse en menos espacio, lo que facilita su carga en memoria y mejora el desempeño general de la base de datos durante las 
consultas.

### 4. Optimización en el procesamiento paralelo
SQL Server puede ejecutar consultas sobre diferentes columnas de manera simultánea, aprovechando los núcleos del procesador para realizar operaciones en paralelo. Esto acelera aún más
el procesamiento de grandes volúmenes de información.

## Implementación de un Índice Columnar

En el contexto del sistema de voto electrónico estudiantil, las consultas más frecuentes serán relacionadas con el conteo de votos por lista, así como la generación de reportes y 
auditorías posteriores. Estas operaciones implican recorrer grandes volúmenes de datos y realizar cálculos agregados, lo que puede afectar el rendimiento si se utiliza únicamente 
índices tradicionales.

La creación de un índice columnar sobre la tabla que almacena los resultados de las elecciones mejoraría la eficiencia notoriamente. En SQL Server, este tipo de índice organiza los
datos por columnas, permitiendo al motor de base de datos leer solo los campos necesarios para una consulta específica, aprovechando la compresión y el procesamiento en paralelo y 
el almacenamiento por columnas, accediendo únicamente a los datos requeridos sin necesidad de leer el resto de columnas de la tabla.

## Aplicación y Consideraciones en el Sistema de Voto Electrónico

Dentro del sistema de voto electrónico desarrollado, los índices columnares se aplican principalmente sobre las tablas con un alto volumen de lecturas. Durante el escrutinio, permiten 
obtener conteos totales y parciales de votos en menor tiempo, optimizando la generación de reportes y estadísticas sin sobrecargar el servidor. Asimismo, resultan útiles para las 
consultas de auditoría que requieren acceder rápidamente a grandes cantidades de datos sin recorrer todas las filas de la tabla.

Sin embargo, es importante tener en cuenta algunas limitaciones. Los índices columnares no son la mejor opción para tablas que reciben actualizaciones o inserciones constantes, ya que 
su estructura está orientada a la lectura y análisis de datos, no al procesamiento transaccional. Por esta razón, su implementación debe concentrarse en las tablas de análisis o 
resultados finales, mientras que las tablas operativas pueden mantener índices tradicionales para un mejor desempeño en operaciones de escritura.

## Conclusión

La incorporación de índices columnares en el sistema de voto electrónico permite optimizar significativamente el rendimiento de las consultas y reportes, especialmente en etapas de 
escrutinio o análisis de resultados. Su estructura orientada a columnas mejora la velocidad de lectura, reduce el uso de memoria y aprovecha mejor los recursos del sistema. 
En conjunto, esta tecnología contribuye a que la base de datos sea más eficiente, escalable y adecuada para el manejo de grandes volúmenes de información electoral.