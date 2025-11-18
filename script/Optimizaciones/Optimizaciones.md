## **Tema: Optimización de consultas a través de índices** 

Objetivos de Aprendizaje:

* Conocer los tipos de índices y sus aplicaciones.  
* Evaluar el impacto de los índices en el rendimiento de las consultas.

Criterios de Evaluación:

* Medición correcta de los tiempos de respuesta antes y después de aplicar índices.  
* Documentación detallada de los planes de ejecución de las consultas.  
* Evaluación de la mejora en el rendimiento.

## **¿Qué son los índices?**

Un índice es una estructura de datos auxiliar que utiliza SQL Server para acelerar la búsqueda de información en una tabla.  
Funciona de manera similar al índice de un libro:

* Sin índice: hay que leer todas las páginas (Table Scan).  
* Con índice: se va directo al capítulo o al rango deseado (Index Seek).

Aunque los índices aceleran las consultas de lectura, también:

* ocupan espacio adicional en disco y memoria,  
* aumentan el costo de inserciones/actualizaciones/borrados,  
* deben ser diseñados estratégicamente para no perjudicar el rendimiento general.

##  **Tipos de índices**

##  **Índice Agrupado (Clustered)**
* Ordena físicamente la tabla según la columna del índice.  
* La tabla es el índice.  
* Solo puede haber uno por tabla.  
* Excelente para búsquedas por rangos (ej. fechas).

## **Índice No Agrupado (Nonclustered)**
* Es una estructura separada de la tabla.  
* Contiene las columnas indexadas \+ puntero a los datos reales.  
* Puede haber muchos por tabla.  
* Si faltan columnas, aparece un Key Lookup (búsqueda adicional).

## **Índice con INCLUDE (Índice Covering)**
* Igual que un índice nonclustered, pero incluye columnas extra.  
* La consulta se resuelve solo usando el índice.  
* Evita Key Lookups y mejora mucho el rendimiento.


## **Plan de ejecución**
El plan de ejecución es el conjunto de pasos que SQL Server decide seguir para resolver una consulta.  
Se genera automáticamente por el motor y permite analizar: cómo accede a los datos, si usa o no índices, cuántas operaciones realiza y qué tan eficiente fue la ejecución.  
Este plan es fundamental para entender por qué una consulta es lenta o rápida, y es la herramienta principal para decidir si conviene crear o modificar un índice.  
Los operadores más importantes son:
* Table Scan: recorre toda la tabla (lo más lento).  
* Clustered Index Scan: recorre todo el índice agrupado.  
* Index Seek: va directo al valor buscado (lo más rápido).  
* Key Lookup: acceso adicional a la tabla cuando faltan columnas en el índice.


## **Objetivo y Justificación:**

Para el tema de optimización con índices, la cátedra solicita trabajar con una tabla que permita insertar grandes volúmenes de datos (100.000 o más registros) y realizar consultas filtradas por un campo de fecha.  
La base del sistema de votación electrónico no cuenta con ninguna tabla adecuada para esta carga masiva sin comprometer la integridad del modelo.  
La tabla voto, por ejemplo, depende de:
* tokens válidos,  
* mesas de votación,  
* listas reales, procesos de escrutinio,  
* restricciones de unicidad (un voto por token).
Insertar cientos de miles de votos rompería la lógica del sistema, las claves foráneas y el escrutinio ya implementado.  
Por esta razón, la solución que se consideró es crear una tabla auxiliar de auditoría, diseñada exclusivamente para pruebas de rendimiento y optimización.

## **Función y sentido de la tabla auditoria**

La tabla auditoria_votos simula un log de eventos del sistema, algo habitual en sistemas reales donde se registran acciones, accesos, procesos automáticos o eventos internos.  
Cada fila representa un “evento” independiente y sencillo:
* fecha_emision: columna clave para aplicar índices y evaluar rangos.  
* mesa: identificador numérico ficticio.  
* lista: simulación de una clasificación.  
* id: campo autonumérico para mantener identidad y orden.

Estos datos no interfieren con el sistema electoral, pero permiten realizar pruebas reales de rendimiento.

## **Objetivos específicos de la tabla de auditoría**

La tabla auditoria_votos permite:

1. Carga masiva (más de 100.000 registros) sin romper integridad.  
2. Consultas filtradas por fecha, necesarias para comparar rendimiento.  
3. Ejecutar una consulta inicial sin índice (baseline).  
4. Crear un índice agrupado (clustered) sobre fecha\_emision y medir mejoras.  
5. Eliminar ese índice y crear uno con INCLUDE para evitar Key Lookups.  
6. Documentar planes de ejecución (Scan vs Seek) y tiempos.  
7. Cumplir 100% con la consigna de optimización sin alterar el modelo principal.