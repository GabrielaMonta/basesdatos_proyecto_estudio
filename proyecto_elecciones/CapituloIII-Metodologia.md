## CAPÍTULO III: METODOLOGÍA SEGUIDA 

## **a) Cómo se realizó el Trabajo Práctico**

El desarrollo del trabajo práctico se llevó adelante siguiendo una metodología incremental y basada en pruebas e investigación.  
Como primer paso, se realizaron estudios sobre el voto electrónico, revisando antecedentes, casos reales de países que implementaron este modelo y análisis de sistemas de votación utilizados en la práctica. Esto permitió comprender el contexto, los riesgos y los requerimientos funcionales necesarios para diseñar un sistema seguro y confiable.  
Una vez recopilada y organizada esta información en un documento base, se avanzó con el diseño del modelo de relación de identidad. Este proceso se desarrolló en múltiples sesiones colaborativas mediante llamadas online, donde se discutieron alternativas, se resolvieron dudas y se seleccionó la estructura más adecuada para representar nuestro sistema electoral.  
Con el modelo definido, se creó un conjunto de datos inicial común para todos los integrantes del grupo, con el fin de garantizar consistencia en las pruebas y facilitar la integración de los distintos temas que debía desarrollar cada miembro.  
A partir de esta base unificada, cada integrante trabajó sobre un módulo específico:

* Transacciones  
* Indices columnares  
* Procedimientos y funciones  
* Optimización de consultas a través de índices

Cada módulo fue diseñado en una carpeta separada, con un archivo SQL correspondiente, y se probó mediante casos de éxito y casos de error creados intencionalmente para evaluar la efectividad de los mecanismos de integridad y asegurar la consistencia de los datos en cada operación.

## **b) Herramientas (Instrumentos y procedimientos)**

Para el desarrollo del trabajo se emplearon las siguientes herramientas:

### Herramientas de desarrollo

* SQL Server Management Studio (SSMS 19):  utilizado para la creación de tablas, ejecución de scripts, diseño de procedimientos almacenados y análisis de índices.  
* SQL Server Express 2022: motor de base de datos utilizado como entorno de pruebas.  
* GitHub: para mantener sincronizados los archivos de scripts y permitir trabajo colaborativo.

### Instrumentos técnicos

* Stored Procedures (SP): para encapsular lógica de validación, inserción, actualización y manejo de errores.  
* Transacciones (BEGIN TRAN, COMMIT, ROLLBACK): empleadas para garantizar la atomicidad de operaciones sensibles.  
* Transacciones anidadas con SAVEPOINT: usadas en el recuento de votos para permitir rollback parcial sin abortar el proceso completo.  
* Índices y estadísticas: aplicados para optimizar consultas de conteo, búsqueda y análisis.  
* Cursores: utilizados únicamente en el módulo de escrutinio para procesar mesas una por una.  
  HASHBYTES \+ GUID: para la generación de tokens seguros y no reversibles en la mesa de identificación.

### Procedimientos

* Diseño de casos de prueba para cada operación (éxito, error y fallos controlados).  
* Ejecución incremental de scripts para garantizar integridad.  
* Validación final de consistencia mediante consultas de verificación.