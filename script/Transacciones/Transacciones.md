# **Tema: Manejo de transacciones y transacciones anidadas**

Objetivos de Aprendizaje:

* Entender la consistencia y atomicidad de las transacciones en bases de datos.  
* Implementar transacciones simples y anidadas para garantizar la integridad de los datos.

Criterios de Evaluación:

* Efectividad de las transacciones al manejar errores.  
* Documentación de pruebas y casos de fallos.  
* Precisión en la implementación del código de transacciones.

## **¿Que es una transacción?**

Una transacción representa una secuencia de operaciones que deben ejecutarse como un todo.  
Su principal propósito es mantener la integridad de la base de datos, asegurando que los datos no queden en estados intermedios o inconsistentes ante fallos, errores o accesos simultáneos.  
Debe cumplir con una serie de propiedades denominadas ACID 

1. **Atomicidad:** todas las operaciones se ejecutan por completo o ninguna se aplica. No se permiten resultados parciales.  
2. **Consistencia**: cada transacción lleva la base de datos a un estado valido a otro valido, preservando las reglas de integridad.  
3. **Aislamiento:** las transacciones se ejecutan de forma independiente, evitando interferencias entre ellas.  
4. **Durabilidad**: una vez confirmados los cambios (commit), estos persisten incluso ante fallos del sistema.

Estas propiedades son esenciales para comprender los principios de consistencia y atomicidad, ejes centrales de esta investigación.

## **Aplicabilidad en el proyecto**

En un sistema de elecciones virtuales, existen varios procesos esenciales como la identificación del votante, la emisión del voto y el escrutinio, que requieren el uso de transacciones para garantizar seguridad y consistencia.  
Para ello, se utilizan Stored Procedures que encapsulan estas operaciones, aplican validaciones y controlan las transacciones con mecanismos como ROLLBACK y SAVEPOINT, asegurando que cada paso crítico se ejecute de manera confiable y sin inconsistencias.

### **1. Mesa de identificacion:** 

**Objetivo:** identificación del estudiante y generación del token de votación. Aplicación de la transacción simple.

**Operaciones involucradas:**

1. Buscar estudiante.  
2. Verificar que no haya votado.  
3. Generar token (y fecha/hora).  
4. Guardar token.  
5. Marcar que pasó por mesa de identificación.

**Justificación de la transacción simple:**

En este bloque se justifica la transacción porque:

* Son operaciones encadenadas: si una falla, no sirve ninguna.  
* Evita que quede un token generado pero no asociado o duplicado.  
* Asegura que el votante no quede a medias.

**Aspectos técnicos a considerar**

##### **1. Generación y protección del token de votación**

Para garantizar la seguridad del proceso electoral y preservar el anonimato del votante, se implementó un mecanismo seguro de generación de tokens utilizando funciones criptográficas proporcionadas por SQL Server.  
Cuando un estudiante se presenta en la mesa de identificación, el sistema genera un token único y no reversible, que luego será utilizado exclusivamente para habilitar la emisión del voto.  
Este token sirve como credencial de una sola vez y reemplaza cualquier dato personal del estudiante durante la votación.

##### **2. Componentes utilizados para la generación del token**

El token se construye a partir de una cadena de caracteres única compuesta por:

* el documento del estudiante,  
* el identificador de la mesa de identificación,  
* la marca de tiempo exacta en que se realizó el registro (SYSDATETIME),  
* un GUID aleatorio generado mediante NEWID().

Ejemplo de una cadena generada:  
40123456-1-2025-11-18T10:32:15.197-77FE1E88-8C78-4C22-9325-080C6C865E81

##### **3. Hash criptográfico mediante SHA-256**

La cadena anterior no se almacena en la base de datos. En su lugar, se aplica la función: HASHBYTES('SHA2\_256', texto).  
*SHA-256* es un algoritmo criptográfico seguro que produce un hash irreversible de 256 bits. Lo que significa que no es posible reconstruir la cadena original ni obtener datos personales del estudiante, no existen colisiones prácticas y nadie puede falsificar un token válido.

Ejemplo de token final almacenado  
0xA4F8C1E6D4958C98B57A1A0C94D92AC0A1C8DBA19F447C0B3217F5158390F4AA

##### **4. Implementación dentro de una transacción**

La generación del token se realizó dentro de una transacción atómica, que garantiza que:

* se verifique que el estudiante exista,  
* se verifique que sea Regular (estado\_id \= 1\),  
* se verifique que no se haya registrado previamente,  
* se registre en la mesa,  
* se genere el token seguro,  
* y si algo falla se realice ROLLBACK y no queda información a medias.

Esto asegura integridad, seguridad y consistencia en el proceso electoral.

###  **2. Emisión del voto en mesa de votación**

**Objetivo:** que el estudiante pueda registrar su voto. Aplicación de transacción simple con posibilidad de rollback.

**Operaciones involucradas.**

1. Validar token y que no esté usado.  
2. Insertar voto (anónimo).  
3. Marcar token como utilizado.

**Justificación de la transacción.**  
En este bloque se justifica la transacción porque:

* no puede quedar un voto sin marcar token como usado (doble voto).  
* no puede marcarse token como usado si el voto no se grabó.  
* se protege la *integridad del proceso electoral*.

**Aspectos técnicos a considerar**  
El proceso debe iniciar con la validación del token, verificando que exista en el sistema y que no haya sido utilizado previamente. De esta manera, se garantiza que cada votante posea un único token válido y que no pueda emitir más de un voto.  
Luego se debe realizar dos operaciones fundamentales:

1. Inserción del voto en la tabla voto  
2. Actualización del estado del token a usado

El cambio de estado del token actúa como un mecanismo de invalidación irreversible, evitando su reutilización y asegurando que el sufragio sea estrictamente único.   
La transacción garantiza atomicidad: si alguna validación falla o si se produce un error durante el registro del voto, el sistema ejecuta un rollback, evitando inconsistencias como votos duplicados o tokens marcados incorrectamente.

### **3. Escrutinio y resultado elección**

**Objetivo:** recalcular el total de votos por mesa y obtener el resultado general de la elección, garantizando integridad incluso ante fallos en mesas individuales.

**Operaciones involucradas:**

1. Eliminar el escrutinio previo (si existe).  
2. Recorrer cada mesa de votación.  
3. Establecer un SAVEPOINT previo al cálculo de cada mesa.  
4. Insertar en escrutinio\_mesa los votos agrupados por lista y mesa.  
5. Si una mesa falla se realiza un rollback parcial al SAVEPOINT (solo esa mesa).  
6. Calcular el resultado final por lista en resultado\_eleccion.  
7. Confirmar toda la transacción al finalizar.

**Justificación**  
El proceso de escrutinio requiere recalcular los votos por mesa y obtener el resultado global de la elección. Este procedimiento es crítico, ya que un error en una mesa no debería afectar el resto del recuento ni invalidar el resultado general.  
Por este motivo, se cree conveniente la utilización de una transacción anidada utilizando SAVEPOINT, lo que permite:

* *Rollback parcial:* si una mesa presenta un error (por ejemplo, datos incompletos, inconsistencias o fallos en la agrupación), el sistema ejecuta un rollback únicamente hasta el SAVEPOINT asociado a esa mesa, sin afectar el procesamiento de las demás.  
* *Continuidad del proceso:* aunque una mesa falle, las demás se siguen procesando normalmente.  
* *Evitar pérdida total del escrutinio:* sin transacciones anidadas, un error en una mesa provocaría la cancelación del cálculo completo.  
* *Consistencia del resultado final:* solo si el recuento general de todas las mesas es correcto, se guarda el resultado final mediante el COMMIT.

**Aspectos técnicos a tener en cuenta**

* Se utiliza BEGIN TRAN para englobar todo el proceso de escrutinio.  
* Se aplican SAVEPOINT antes del cálculo de cada mesa para permitir un control fino del rollback.  
* Si el cálculo de una mesa falla, se ejecuta: ROLLBACK TRAN saveMesa; evitando que errores puntuales afecten el resto del recuento. El cálculo del resultado general se realiza solo si el escrutinio por mesa fue exitoso, garantizando consistencia.  
* La operación completa se confirma únicamente con: COMMIT TRAN; asegurando que todos los datos sean correctos antes de almacenarse.  
* Si ocurre cualquier error grave (fuera de una mesa particular), se ejecuta un rollback total, protegiendo la integridad de los resultados.

### **Bibliografía consultada:**

[https://learn.microsoft.com/es-es/sql/t-sql/language-elements/transactions-transact-sql?view=sql-server-ver17](https://learn.microsoft.com/es-es/sql/t-sql/language-elements/transactions-transact-sql?view=sql-server-ver17)

