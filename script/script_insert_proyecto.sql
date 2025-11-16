-- SCRIPT "Voto Electronico"
-- INSERCIÓN DEL LOTE DE DATOS

USE proyecto_elecciones;
GO


-- ----------------------------------------------------------------------------
-- TABLA: universidad
-- ----------------------------------------------------------------------------
INSERT INTO universidad (nombre)
VALUES ('Universidad Nacional de Corrientes');

-- Ver resultado
SELECT * FROM universidad;
GO

-- ----------------------------------------------------------------------------
-- TABLA: facultad
-- ----------------------------------------------------------------------------
INSERT INTO facultad (nombre_facultad, direccion, universidad_id)
VALUES ('Facultad de Ciencias Exactas y Naturales', 'Av. Libertad 5400', 1);

-- Ver resultado
SELECT * FROM facultad;
GO

-- ----------------------------------------------------------------------------
-- TABLA: carrera
-- ----------------------------------------------------------------------------
INSERT INTO carrera (nombre_carrera)
VALUES ('Licenciatura en Sistemas'),
       ('Ingeniería en Computación'),
       ('Profesorado en Matemática');

-- Ver resultado
SELECT * FROM carrera;
GO

-- ----------------------------------------------------------------------------
-- TABLA: facultad_carrera
-- ----------------------------------------------------------------------------
INSERT INTO facultad_carrera (universidad_id, facultad_id, carrera_id)
VALUES (1, 1, 1),
       (1, 1, 2),
       (1, 1, 3);

-- Ver resultado
SELECT * FROM facultad_carrera;
GO

-- ----------------------------------------------------------------------------
-- TABLA: estado_carrera
-- ----------------------------------------------------------------------------
INSERT INTO estado_carrera (nombre)
VALUES ('Activo'),
       ('Egresado'),
       ('Inactivo');

-- Ver resultado
SELECT * FROM estado_carrera;
GO



-- ----------------------------------------------------------------------------
-- TABLA: Estudiante LOTE 1
-- ----------------------------------------------------------------------------

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40901234, 'Agustina', 'Mendoza', 'agustina.mendoza@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (41012345, 'Franco', 'Benítez', 'franco.benitez@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (41123456, 'Jazmín', 'Romero', 'jazmin.romero@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (41234567, 'Tomás', 'Herrera', 'tomas.herrera@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (41345678, 'Carolina', 'Acosta', 'carolina.acosta@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (41456789, 'Federico', 'Gómez', 'federico.gomez@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (41567890, 'Milagros', 'Luna', 'milagros.luna@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (41678901, 'Ezequiel', 'Suárez', 'ezequiel.suarez@estudiante.unne.edu.ar');
-- Verificar resultados
SELECT * FROM estudiante;
GO


-- Candidatos
-- LOTE 2 DE CANDIDATOS
INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35789012, 'Federico', 'Ramos', 'federico.ramos@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35890123, 'Agustina', 'Pereyra', 'agustina.pereyra@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35901234, 'Luciano', 'Navarro', 'luciano.navarro@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (36012345, 'Camila', 'Sosa', 'camila.sosa@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (36123456, 'Tomás', 'Romero', 'tomas.romero@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (36234567, 'Valeria', 'Herrera', 'valeria.herrera@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (36345678, 'Nicolás', 'Medina', 'nicolas.medina@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (36456789, 'Julieta', 'Figueroa', 'julieta.figueroa@estudiante.unne.edu.ar');




-- ----------------------------------------------------------------------------
-- TABLA: carrera_estudiante
-- ----------------------------------------------------------------------------
INSERT INTO carrera_estudiante (carrera_id, documento_estudiante, año_ingreso, año_egreso, estado_id)
VALUES 
    (1, 40123456, '2021-03-01', NULL, 1),
    (1, 40234567, '2021-03-01', NULL, 1),
    (2, 40345678, '2022-03-01', NULL, 1),
    (2, 40456789, '2022-03-01', NULL, 1),
    (1, 40567890, '2020-03-01', NULL, 1),
    (3, 40678901, '2021-03-01', NULL, 1),
    (1, 40789012, '2023-03-01', NULL, 1),
    (2, 40890123, '2023-03-01', NULL, 1),
    (1, 35123456, '2019-03-01', NULL, 1),
    (1, 35234567, '2019-03-01', NULL, 1),
    (2, 35345678, '2019-03-01', NULL, 1),
    (2, 35456789, '2020-03-01', NULL, 1),
    (1, 35567890, '2020-03-01', NULL, 1),
    (1, 35678901, '2020-03-01', NULL, 1);

-- Ver resultado
SELECT * FROM carrera_estudiante;
GO

-- ----------------------------------------------------------------------------
-- TABLA: partido
-- ----------------------------------------------------------------------------
INSERT INTO partido (nombre_partido)
VALUES ('Frente Estudiantil Azul'),
       ('Movimiento Verde Universitario'),
       ('Agrupación Roja por los Derechos');

-- Ver resultado
SELECT * FROM partido;
GO

-- ----------------------------------------------------------------------------
-- TABLA: lista
-- ----------------------------------------------------------------------------
INSERT INTO lista (partido_id)
VALUES (1), -- Lista 1: Frente Azul
       (2), -- Lista 2: Movimiento Verde
       (3); -- Lista 3: Agrupación Roja

-- Ver resultado
SELECT * FROM lista;
GO

-- ----------------------------------------------------------------------------
-- TABLA: cargo_eleccion
-- ----------------------------------------------------------------------------
INSERT INTO cargo_eleccion (nombre, descripcion)
VALUES ('Presidente', 'Representante principal del centro de estudiantes'),
       ('Vicepresidente', 'Segundo al mando del centro de estudiantes'),
       ('Secretario General', 'Encargado de actas y documentación'),
       ('Tesorero', 'Administrador de recursos económicos');

-- Ver resultado
SELECT * FROM cargo_eleccion;
GO

-- ----------------------------------------------------------------------------
-- TABLA: banca
-- ----------------------------------------------------------------------------
INSERT INTO banca (nombre)
VALUES ('Banca Titular 1'),
       ('Banca Titular 2'),
       ('Banca Suplente 1');

-- Ver resultado
SELECT * FROM banca;
GO

-- ----------------------------------------------------------------------------
-- TABLA: orden
-- ----------------------------------------------------------------------------
INSERT INTO orden (numero)
VALUES (1), (2), (3), (4);

-- Ver resultado
SELECT * FROM orden;
GO

-- ----------------------------------------------------------------------------
-- TABLA: cargo_banca
-- ----------------------------------------------------------------------------
INSERT INTO cargo_banca (cargo_id, banca_id, orden_id)
VALUES (1, 1, 1), -- Presidente, Banca Titular 1, Orden 1
       (2, 1, 2), -- Vicepresidente, Banca Titular 1, Orden 2
       (3, 2, 1), -- Secretario, Banca Titular 2, Orden 1
       (4, 2, 2); -- Tesorero, Banca Titular 2, Orden 2

-- Ver resultado
SELECT * FROM cargo_banca;
GO

-- ----------------------------------------------------------------------------
-- TABLA: cargo_banca_estudiante
-- ----------------------------------------------------------------------------
INSERT INTO cargo_banca_estudiante (cargo_id, banca_id, orden_id, documento_estudiante)
VALUES (1, 1, 1, 35123456), -- Juan Pérez - Presidente
       (2, 1, 2, 35234567), -- María González - Vicepresidente
       (1, 1, 1, 35345678), -- Carlos López - Presidente
       (2, 1, 2, 35456789), -- Ana Martínez - Vicepresidente
       (1, 1, 1, 35567890), -- Pedro Fernández - Presidente
       (2, 1, 2, 35678901); -- Laura Rodríguez - Vicepresidente

-- Ver resultado
SELECT * FROM cargo_banca_estudiante;
GO

-- ----------------------------------------------------------------------------
-- TABLA: lista_cargos
-- ----------------------------------------------------------------------------
INSERT INTO lista_cargos (lista_id, cargo_id, banca_id, orden_id, documento_estudiante)
VALUES 
    -- Lista 1 (Frente Azul)
    (1, 1, 1, 1, 35123456), -- Juan Pérez - Presidente
    (1, 2, 1, 2, 35234567), -- María González - Vice
    -- Lista 2 (Movimiento Verde)
    (2, 1, 1, 1, 35345678), -- Carlos López - Presidente
    (2, 2, 1, 2, 35456789), -- Ana Martínez - Vice
    -- Lista 3 (Agrupación Roja)
    (3, 1, 1, 1, 35567890), -- Pedro Fernández - Presidente
    (3, 2, 1, 2, 35678901); -- Laura Rodríguez - Vice

-- Ver resultado
SELECT * FROM lista_cargos;
GO

-- ----------------------------------------------------------------------------
-- TABLA: eleccion
-- ----------------------------------------------------------------------------
INSERT INTO eleccion (año)
VALUES (2024);

-- Ver resultado
SELECT * FROM eleccion;
GO

-- ----------------------------------------------------------------------------
-- TABLA: mesa_identificacion
-- ----------------------------------------------------------------------------
INSERT INTO mesa_identificacion (nro_mesa_identificacion, documento_estudiante, eleccion_id)
VALUES (1, 40123456, 1),
       (1, 40234567, 1),
       (2, 40345678, 1),
       (2, 40456789, 1),
       (3, 40567890, 1),
       (3, 40678901, 1),
       (4, 40789012, 1),
       (4, 40890123, 1);

-- Ver resultado
SELECT * FROM mesa_identificacion;
GO

-- ----------------------------------------------------------------------------
-- TABLA: mesa_votacion
-- ----------------------------------------------------------------------------
INSERT INTO mesa_votacion (nro_mesa_votacion)
VALUES (1), (2), (3), (4);

-- Ver resultado
SELECT * FROM mesa_votacion;
GO

-- ----------------------------------------------------------------------------
-- TABLA: token_votante
-- ----------------------------------------------------------------------------
INSERT INTO token_votante (codigo_token, usado, mesa_identificacion_id)
VALUES 
    (HASHBYTES('SHA2_256', '40123456-2024-1'), 0, 1),
    (HASHBYTES('SHA2_256', '40234567-2024-1'), 0, 2),
    (HASHBYTES('SHA2_256', '40345678-2024-1'), 0, 3),
    (HASHBYTES('SHA2_256', '40456789-2024-1'), 0, 4),
    (HASHBYTES('SHA2_256', '40567890-2024-1'), 0, 5),
    (HASHBYTES('SHA2_256', '40678901-2024-1'), 0, 6),
    (HASHBYTES('SHA2_256', '40789012-2024-1'), 0, 7),
    (HASHBYTES('SHA2_256', '40890123-2024-1'), 0, 8);

-- Ver resultado
SELECT * FROM token_votante;
GO

