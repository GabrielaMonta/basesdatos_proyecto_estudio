# Introducción: Fundamento de los Procedimientos Almacenados y Funciones

Un procedimiento almacenado en SQL Server es una unidad de código precompilado que contiene una o más instrucciones Transact-SQL y se ejecuta directamente en el servidor. Su uso permite encapsular la lógica de negocio, reducir errores, mejorar el rendimiento y asegurar comportamientos uniformes en todas las operaciones que interactúan con la base de datos.

Entre sus características más importantes se destacan:

- Aceptan parámetros de entrada y salida.
- Permiten administrar transacciones (BEGIN TRAN / COMMIT / ROLLBACK).
- Pueden implementar validaciones complejas y reglas de negocio.
- Facilitan el control de permisos y la seguridad del sistema.
- Pueden devolver múltiples conjuntos de resultados o códigos de estado.

Una función almacenada (User Defined Function) también contiene lógica SQL, pero con restricciones más estrictas:

- Devuelven siempre un valor (escalar o una tabla).
- No permiten transacciones.
- Solo pueden leer datos.
- Pueden ser utilizadas dentro de SELECT, JOIN o WHERE.
- No aceptan parámetros de salida.

Ambas herramientas —procedimientos y funciones— permiten centralizar la lógica de negocio, mejorar la eficiencia y mantener la coherencia del sistema a largo plazo.

---

## Implementación en SQL Server

En la implementación se utilizaron procedimientos almacenados definidos por el usuario (User Defined Procedures) y funciones personalizadas, con el objetivo de:

- Centralizar validaciones.
- Evitar duplicación de lógica.
- Optimizar consultas frecuentes.
- Mantener la integridad del módulo Estudiante.
- Asegurar coherencia en reglas del sistema electoral.

Todos los objetos fueron creados mediante `CREATE PROCEDURE` y `CREATE FUNCTION`, respetando las restricciones propias de cada tipo.

Se desarrollaron tres procedimientos almacenados principales:

- `sp_InsertarEstudiante` (inserción)
- `sp_ModificarEstudiante` (actualización)
- `sp_EliminarEstudiante` (eliminación)

Los procedimientos incorporan validaciones mediante expresiones `EXISTS`, manejo de errores mediante `TRY/CATCH` y generación de excepciones con `THROW`, lo que permite frenar la ejecución con mensajes claros y evitar inconsistencias. La lógica de negocio queda concentrada del lado del servidor, garantizando reglas uniformes sin depender del código de las aplicaciones cliente.

---

## A) Procedimiento de Inserción con Validaciones

`sp_InsertarEstudiante` realiza verificaciones antes de permitir el alta:

- Documento no duplicado.
- Email único.
- Documento positivo.
- Campos obligatorios.

Solo ejecuta la inserción si supera todas las verificaciones, garantizando integridad desde el primer registro ingresado.

---

## B) Procedimiento de Actualización Validada

`sp_ModificarEstudiante` asegura que:

- El registro exista.
- La unicidad del email se mantenga (evitar que dos estudiantes compartan email).
- El estudiante pueda conservar su email actual sin conflicto.

Este diseño evita inconsistencias sin bloquear actualizaciones legítimas.

---

## C) Procedimiento de Eliminación con Integridad Referencial

`sp_EliminarEstudiante` incorpora validaciones encadenadas para impedir la eliminación si afecta al sistema electoral.

El procedimiento comprueba:

- Que el registro exista.
- Que el estudiante no sea candidato.
- Que no esté asociado a ninguna lista.
- Que no haya emitido su voto.

Solo si pasa todas las validaciones se ejecuta la eliminación, protegiendo la integridad de relaciones interdependientes.

---

## Funciones Implementadas

Se desarrollaron tres funciones auxiliares que complementan a los procedimientos:

### fn_ObtenerNombreCompleto

Devuelve el nombre completo concatenado del estudiante.

### fn_ExisteEstudiante

Verifica la existencia del estudiante mediante una expresión optimizada con `EXISTS`.

### fn_ListarEstudiantesPorDominio

Función de tabla en línea que retorna estudiantes filtrados por dominio de email, útil para reportes y consultas dinámicas.

Las funciones agregan modularidad, evitando repetir lógica y facilitando el mantenimiento del sistema.

---

## Integridad

Los procedimientos encapsulan las reglas de negocio y validaciones internas, impidiendo la inserción o modificación de datos inconsistentes.
```sql
IF @documento <= 0 
    THROW 50001, 'Documento inválido.', 1;
```

---

## Seguridad

En lugar de otorgar permisos a nivel tabla, se habilita solo la ejecución de procedimientos.
```sql
GRANT EXECUTE ON sp_InsertarEstudiante TO usuario_app;
```

Esto evita que usuarios externos realicen manipulaciones directas sobre las tablas.

---

## Mantenibilidad

Toda la lógica permanece en un solo lugar. Si cambia una regla (por ejemplo, validación de email), se modifica únicamente dentro del procedimiento.

---

## Pruebas de Eficiencia

Se midió el rendimiento utilizando `SYSDATETIME()`,permite obtener resultados en ms, y mas efectivo que con getDate():
```sql
DECLARE @inicio DATETIME2 = SYSDATETIME();
-- Ejecución de alto volumen de operaciones sin validaciones
DECLARE @fin DATETIME2 = SYSDATETIME();
```

Los resultados mostraron que:

- Las operaciones directas sin validación son más rápidas.
- Los procedimientos almacenados agregan validaciones necesarias y reducen errores.
- El costo adicional de tiempo (10–20%) es aceptable frente a la mejora en calidad e integridad de los datos.