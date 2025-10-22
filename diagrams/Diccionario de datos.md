# Diccionario de Datos - Sistema de Elecciones Estudiantiles


## 1. CARGO_ELECCION
Almacena los diferentes tipos de cargos disponibles en las elecciones estudiantiles.


| Campo | Tipo de Dato | Restricciones | Descripci�n |
|-------|--------------|---------------|-------------|
| cargo_id | INT | PK, NOT NULL | Identificador �nico del cargo |
| nombre | VARCHAR(50) | NOT NULL | Nombre del cargo electoral |
| descripcion | VARCHAR(200) | NOT NULL | Descripci�n detallada del cargo |


---


## 2. ESTUDIANTE
Contiene la informaci�n personal de los estudiantes participantes del sistema electoral.


| Campo | Tipo de Dato | Restricciones | Descripci�n |
|-------|--------------|---------------|-------------|
| documento_estudiante | INT | PK, NOT NULL | N�mero de documento del estudiante |
| nombre | VARCHAR(50) | NOT NULL | Nombre del estudiante |
| apellido | VARCHAR(50) | NOT NULL | Apellido del estudiante |
| email | VARCHAR(80) | NOT NULL, UNIQUE | Correo electr�nico del estudiante |


---


## 3. CARRERA
Define las carreras universitarias disponibles en el sistema.


| Campo | Tipo de Dato | Restricciones | Descripci�n |
|-------|--------------|---------------|-------------|
| carrera_id | INT | PK, NOT NULL | Identificador �nico de la carrera |
| nombre_carrera | VARCHAR(100) | NOT NULL | Nombre de la carrera |


---


## 4. UNIVERSIDAD
Almacena informaci�n de las universidades participantes.


| Campo | Tipo de Dato | Restricciones | Descripci�n |
|-------|--------------|---------------|-------------|
| universidad_id | INT | PK, NOT NULL | Identificador �nico de la universidad |
| nombre | VARCHAR(200) | NOT NULL | Nombre de la universidad |


---


## 5. FACULTAD
Contiene las facultades pertenecientes a cada universidad.


| Campo | Tipo de Dato | Restricciones | Descripci�n |
|-------|--------------|---------------|-------------|
| facultad_id | INT | PK, NOT NULL | Identificador �nico de la facultad |
| nombre_facultad | VARCHAR(200) | NOT NULL | Nombre de la facultad |
| direccion | VARCHAR(150) | NOT NULL | Direcci�n f�sica de la facultad |
| universidad_id | INT | PK, FK, NOT NULL | Referencia a la universidad |


---
