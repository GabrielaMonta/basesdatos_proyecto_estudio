CREATE DATABASE proyecto_elecciones;
GO

USE proyecto_elecciones;
GO

CREATE TABLE cargo_eleccion
(
  cargo_id INT IDENTITY(1,1) NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  descripcion VARCHAR(200) NOT NULL,
  CONSTRAINT PK_cargo_eleccion PRIMARY KEY (cargo_id)
);


CREATE TABLE estudiante
(
  documento_estudiante INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  email VARCHAR(80) NOT NULL,
  CONSTRAINT PK_estudiante PRIMARY KEY  (documento_estudiante),
  CONSTRAINT UQ_email UNIQUE (email)
);


CREATE TABLE carrera
(
  carrera_id INT IDENTITY(1,1) NOT NULL,
  nombre_carrera VARCHAR(100) NOT NULL,
  CONSTRAINT PK_carrera PRIMARY KEY (carrera_id)
);

CREATE TABLE universidad
(
  universidad_id INT IDENTITY(1,1) NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  CONSTRAINT PK_universidad PRIMARY KEY (universidad_id)
);

CREATE TABLE facultad
(
  facultad_id INT NOT NULL,
  nombre_facultad VARCHAR(200) NOT NULL,
  direccion VARCHAR(150) NOT NULL,
  universidad_id INT NOT NULL,
 CONSTRAINT PK_facultad PRIMARY KEY (universidad_id, facultad_id),
 CONSTRAINT FK_facultad_universidad FOREIGN KEY (universidad_id) REFERENCES universidad(universidad_id)
);

CREATE TABLE estado_carrera
(
  estado_id INT IDENTITY(1,1)NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  CONSTRAINT PK_estado_carrera PRIMARY KEY (estado_id)
);

CREATE TABLE carrera_estudiante
(
  carrera_id INT NOT NULL,
  documento_estudiante INT NOT NULL,
  año_ingreso DATE NOT NULL,
  año_egreso DATE,
  estado_id INT NOT NULL,
  CONSTRAINT PK_carrera_estudiante PRIMARY KEY (carrera_id, documento_estudiante),
  CONSTRAINT FK_carrera_estudiante_carrera FOREIGN KEY (carrera_id) REFERENCES carrera(carrera_id),
  CONSTRAINT FK_carrera_estudiante_estudiante FOREIGN KEY (documento_estudiante) REFERENCES estudiante(documento_estudiante),
  CONSTRAINT FK_carrera_estudiante_estado_carrera FOREIGN KEY (estado_id) REFERENCES estado_carrera(estado_id)
);

CREATE TABLE facultad_carrera
(
  facultad_id INT NOT NULL,
  universidad_id INT NOT NULL,
  carrera_id INT NOT NULL,
  CONSTRAINT PK_facultad_carrera PRIMARY KEY (facultad_id, universidad_id, carrera_id),
  CONSTRAINT FK_facultad_carrera_facultad FOREIGN KEY (facultad_id, universidad_id) REFERENCES facultad(universidad_id, facultad_id),
  CONSTRAINT FK_facultad_carrera_carrera FOREIGN KEY (carrera_id) REFERENCES carrera(carrera_id)
);

CREATE TABLE banca
(
  banca_id INT IDENTITY(1,1) NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  CONSTRAINT PK_banca PRIMARY KEY (banca_id)
);

CREATE TABLE orden
(
  orden_id INT IDENTITY(1,1) NOT NULL,
  numero INT NOT NULL,
  CONSTRAINT PK_orden PRIMARY KEY (orden_id)
);

CREATE TABLE cargo_banca
(
  cargo_id INT NOT NULL,
  banca_id INT NOT NULL,
  orden_id INT NOT NULL,
  CONSTRAINT PK_cargo_banca PRIMARY KEY (cargo_id, banca_id, orden_id),
  CONSTRAINT FK_cargo_banca_cargo_eleccion FOREIGN KEY (cargo_id) REFERENCES cargo_eleccion(cargo_id),
  CONSTRAINT FK_cargo_banca_banca FOREIGN KEY (banca_id) REFERENCES banca(banca_id),
  CONSTRAINT FK_cargo_banca_orden  FOREIGN KEY (orden_id) REFERENCES orden(orden_id)
);

CREATE TABLE partido
(
  partido_id INT IDENTITY(1,1) NOT NULL,
  nombre_partido VARCHAR(100) NOT NULL,
  CONSTRAINT PK_partido PRIMARY KEY (partido_id)
);

CREATE TABLE lista
(
  lista_id INT IDENTITY(1,1) NOT NULL,
  partido_id INT NOT NULL,
  CONSTRAINT PK_lista PRIMARY KEY (lista_id),
  CONSTRAINT FK_lista_partido FOREIGN KEY (partido_id) REFERENCES partido(partido_id)
);

CREATE TABLE cargo_banca_estudiante
(
  cargo_id INT NOT NULL,
  banca_id INT NOT NULL,
  orden_id INT NOT NULL,
  documento_estudiante INT NOT NULL,
  CONSTRAINT PK_cargo_banca_estudiante PRIMARY KEY (cargo_id, banca_id, orden_id, documento_estudiante),
  CONSTRAINT FK_cargo_banca_estudiante_cargo_banca FOREIGN KEY (cargo_id, banca_id, orden_id) REFERENCES cargo_banca(cargo_id, banca_id, orden_id),
  CONSTRAINT FK_cargo_banca_estudiante_estudiante FOREIGN KEY (documento_estudiante) REFERENCES estudiante(documento_estudiante)
);

CREATE TABLE lista_cargos
(
  lista_id INT NOT NULL,
  cargo_id INT NOT NULL,
  banca_id INT NOT NULL,
  orden_id INT NOT NULL,
  documento_estudiante INT NOT NULL,
  CONSTRAINT PK_lista_cargos PRIMARY KEY (lista_id, cargo_id, banca_id, orden_id, documento_estudiante),
  CONSTRAINT FK_lista_cargos_lista FOREIGN KEY (lista_id) REFERENCES lista(lista_id),
  CONSTRAINT FK_lista_cargos_cargo_banca_estudiante FOREIGN KEY (cargo_id, banca_id, orden_id, documento_estudiante) REFERENCES cargo_banca_estudiante(cargo_id, banca_id, orden_id, documento_estudiante)
);


CREATE TABLE eleccion
(
  eleccion_id INT IDENTITY(1,1) NOT NULL,
  año INT NOT NULL DEFAULT YEAR(GETDATE()),
  CONSTRAINT PK_eleccion PRIMARY KEY (eleccion_id)
);

CREATE TABLE mesa_identificacion
(
  mesa_identificacion_id INT IDENTITY(1,1) NOT NULL,
  nro_mesa_identificacion INT NOT NULL,
  documento_estudiante INT NOT NULL,
  eleccion_id INT NOT NULL,
 CONSTRAINT PK_mesa_identificacion PRIMARY KEY (mesa_identificacion_id),
 CONSTRAINT FK_mesa_identificacion_estudiante FOREIGN KEY (documento_estudiante) REFERENCES estudiante(documento_estudiante),
 CONSTRAINT FK_mesa_identificacion_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id)
);

CREATE TABLE token_votante
(
  token_id INT IDENTITY(1,1) NOT NULL,
  codigo_token varbinary(64) NOT NULL,
  usado BIT NOT NULL DEFAULT 0,
  mesa_identificacion_id INT NOT NULL,
  CONSTRAINT PK_token_votante PRIMARY KEY (token_id),
  CONSTRAINT FK_token_votante_mesa_identificacion FOREIGN KEY (mesa_identificacion_id) REFERENCES mesa_identificacion(mesa_identificacion_id),
  CONSTRAINT UQ_codigo_token UNIQUE (codigo_token)
);


CREATE TABLE mesa_votacion
(
  mesa_votacion_id INT IDENTITY(1,1) NOT NULL,
  nro_mesa_votacion INT NOT NULL,
  CONSTRAINT PK_mesa_votacion PRIMARY KEY (mesa_votacion_id)
);

CREATE TABLE voto
(
  token_id INT NOT NULL,
  fecha_emision DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
  lista_id INT NOT NULL,
  mesa_votacion_id INT NOT NULL,
  CONSTRAINT PK_voto  PRIMARY KEY (token_id),
  CONSTRAINT FK_voto_lista FOREIGN KEY (lista_id) REFERENCES lista(lista_id),
  CONSTRAINT FK_voto_token_votante FOREIGN KEY (token_id) REFERENCES token_votante(token_id),
  CONSTRAINT FK_voto_mesa_votacion FOREIGN KEY (mesa_votacion_id) REFERENCES mesa_votacion(mesa_votacion_id)
);

CREATE TABLE resultado_eleccion
(
  lista_id INT NOT NULL,
  eleccion_id INT NOT NULL,
  resultado INT NOT NULL,
  CONSTRAINT PK_resultado_eleccion PRIMARY KEY (lista_id, eleccion_id),
  CONSTRAINT FK_resultado_eleccion_lista FOREIGN KEY (lista_id) REFERENCES lista(lista_id),
  CONSTRAINT FK_resultado_eleccion_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id)
);

CREATE TABLE escrutinio_mesa
(
  lista_id INT NOT NULL,
  mesa_votacion_id INT NOT NULL,
  cantidad_votos INT NOT NULL,
  CONSTRAINT PK_escrutinio_mesa PRIMARY KEY (lista_id, mesa_votacion_id),
  CONSTRAINT FK_escrutinio_mesa_lista FOREIGN KEY (lista_id) REFERENCES lista(lista_id),
  CONSTRAINT FK_escrutinio_mesa_mesa_votacion FOREIGN KEY (mesa_votacion_id) REFERENCES mesa_votacion(mesa_votacion_id)
);