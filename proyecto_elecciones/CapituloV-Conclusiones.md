## CAPÍTULO V: CONCLUSIONES

El desarrollo del sistema de voto electrónico estudiantil nos permite conocer y poner en práctica la importancia de 
aplicar técnicas avanzadas de diseño y administración de base de datos para garantizar que el proceso sea seguro, eficiente 
y sobre todo confiable. 

En primer lugar, el uso de procedimientos y funciones almacenadas fortalecieron el rendimiento y seguridad del sistema, 
evidenciando la importancia de la integridad y confiabilidad de la información. Estos elementos permiten controlar de manera 
rigurosa las operaciones críticas: mediante validaciones, manejo de errores y encapsulamiento de lógica, los procedimientos 
garantizan la integridad general del sistema y evitan manipulaciones directas sobre las tablas.  
Por su parte, las funciones almacenadas aportaron modularidad y reutilización en tareas de consulta y verificación, contribuyendo
a una arquitectura más ordenada, clara y mantenible.

Por otro lado, la optimización mediante el uso de índices tradicionales permitió apreciar claramente el impacto que tienen en
el rendimiento de consultas sobre grandes volúmenes de información. A través de la tabla auxiliar `auditoria` fue posible observar
la diferencia entre los distintos métodos de búsqueda y visualizar cómo un índice agrupado o un índice con columnas incluidas puede 
reducir de forma drástica los tiempos de respuesta y mejorar significativamente la eficiencia en consultas por rango de fechas.

La incorporación del manejo de transacciones y transacciones anidadas ayudó a garantizar la seguridad y consistencia del proceso electoral. 
Implementar transacciones simples en las partes más fundamentales del sistema —como la mesa de identificación y la mesa de votación— permitió 
asegurar que todo el flujo funcione correctamente y que, ante cualquier error, el proceso no se detenga ni deje datos inconsistentes, algo 
esencial si el sistema llegara a utilizarse en un escenario real y a gran escala.  
El uso de SAVEPOINT dentro del recuento por mesa posibilitó realizar rollbacks parciales, evitando que errores aislados afecten el resultado 
general del escrutinio.  
Por otro lado, la aplicación de hashing con SHA-256, junto con el uso de GUID para la generación de tokens, reforzó el anonimato y la protección 
de datos sensibles, alineándose con estándares modernos de seguridad.

Por último, el módulo de índices columnares y su aplicación fue útil para el análisis intensivo de datos y los procesos de escrutinio.
La capacidad de trabajar por columnas y ejecutar consultas en paralelo nos permite ver la diferencia de tiempo en lectura que se presenta 
al aplicarse frente a la ejecución sin ellos. Si bien no son ideales para tablas de escritura intensiva, su uso en tablas analíticas o de 
resultados electorales aporta una mejora significativa en escalabilidad y eficiencia.

En conclusión el uso de los cuatro ejes presentados nos permitió construir un sistema de voto electrónico sólido, seguro y eficiente. 
El proyecto no solo nos permitió implementar una solución funcional sino también comprender la relevancia de los diferentes mecanismos en 
sistemas críticos aplicados en un entorno real.
