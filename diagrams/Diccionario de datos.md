# Diccionario de Datos - Sistema de Elecciones Estudiantiles


## 1. CARGO_ELECCION
Almacena los diferentes tipos de cargos disponibles en las elecciones estudiantiles.


| Campo | Tipo de Dato | Restricciones | Descripción |
|-------|--------------|---------------|-------------|
| cargo_id | INT | PK, NOT NULL | Identificador único del cargo |
| nombre | VARCHAR(50) | NOT NULL | Nombre del cargo electoral |
| descripcion | VARCHAR(200) | NOT NULL | Descripción detallada del cargo |


---


## 2. ESTUDIANTE
Contiene la información personal de los estudiantes participantes del sistema electoral.


| Campo | Tipo de Dato | Restricciones | Descripción |
|-------|--------------|---------------|-------------|
| documento_estudiante | INT | PK, NOT NULL | Número de documento del estudiante |
| nombre | VARCHAR(50) | NOT NULL | Nombre del estudiante |
| apellido | VARCHAR(50) | NOT NULL | Apellido del estudiante |
| email | VARCHAR(80) | NOT NULL, UNIQUE | Correo electrónico del estudiante |


---


## 3. CARRERA
Define las carreras universitarias disponibles en el sistema.


| Campo | Tipo de Dato | Restricciones | Descripción |
|-------|--------------|---------------|-------------|
| carrera_id | INT | PK, NOT NULL | Identificador único de la carrera |
| nombre_carrera | VARCHAR(100) | NOT NULL | Nombre de la carrera |


---


## 4. UNIVERSIDAD
Almacena información de las universidades participantes.


| Campo | Tipo de Dato | Restricciones | Descripción |
|-------|--------------|---------------|-------------|
| universidad_id | INT | PK, NOT NULL | Identificador único de la universidad |
| nombre | VARCHAR(200) | NOT NULL | Nombre de la universidad |


---


## 5. FACULTAD
Contiene las facultades pertenecientes a cada universidad.


| Campo | Tipo de Dato | Restricciones | Descripción |
|-------|--------------|---------------|-------------|
| facultad_id | INT | PK, NOT NULL | Identificador único de la facultad |
| nombre_facultad | VARCHAR(200) | NOT NULL | Nombre de la facultad |
| direccion | VARCHAR(150) | NOT NULL | Dirección física de la facultad |
| universidad_id | INT | PK, FK, NOT NULL | Referencia a la universidad |


---
