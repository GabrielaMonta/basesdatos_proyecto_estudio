-- SCRIPT "Voto Electronico"
-- INSERCIÓN DEL LOTE DE DATOS

USE proyecto_elecciones;
GO


-- ----------------------------------------------------------------------------
-- TABLA: universidad
-- ----------------------------------------------------------------------------
INSERT INTO universidad (nombre)
VALUES ('Universidad Nacional del Nordeste');

-- Ver resultado
SELECT * FROM universidad;
GO

-- ----------------------------------------------------------------------------
-- TABLA: facultad
-- ----------------------------------------------------------------------------
INSERT INTO facultad (nombre_facultad, direccion, universidad_id)
VALUES ('Facultad de Ciencias Exactas y Naturales', 'Av. Libertad 5400, Corrientes - Corrientes', 1);

-- Ver resultado
SELECT * FROM facultad;
GO

-- ----------------------------------------------------------------------------
-- TABLA: carrera
-- ----------------------------------------------------------------------------
INSERT INTO carrera (nombre_carrera)
VALUES ('Licenciatura en Sistemas'),
       ('Agrimensura'),
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
VALUES ('Regular'),
       ('Egresado/a'),
       ('Libre');

-- Ver resultado
SELECT * FROM estado_carrera;
GO



-- ----------------------------------------------------------------------------
-- TABLA: Estudiante LOTE 1
-- ----------------------------------------------------------------------------
INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40123456, 'Sofía', 'García', 'sofia_garcia@unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40234567, 'Mateo', 'Fernández', 'matefer@hotmail.com');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40345678, 'Valentina', 'López', 'valentinalo@hotmail.com');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40456789, 'Santiago', 'Martínez', 'santiago.martinez@hotmail.com');

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

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40567890, 'Camila', 'Vega', 'camila.vega@hotmail.com');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40678901, 'Bruno', 'Silva', 'brunosilva@outlook.com');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40789012, 'Sabrina', 'Cruz', 'sabri.cruz@unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (40890123, 'Lucas', 'Ortiz', 'ortiz.lucas@gmail.com');

-- Verificar resultados
SELECT * FROM estudiante;
GO


-- Candidatos
-- LOTE 2 DE CANDIDATOS
INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35123456, 'Juan', 'Perez', 'juan.perez@estudiante.unne.edu.ar');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35234567, 'María', 'González', 'maria.gonzalez@gmail.com');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35345678, 'Carlos', 'López', 'carlos.lopez@unne.com');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35456789, 'Ana', 'Martínez', 'ana.martinez@estudiante.unne.edu.ar');

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

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35567890, 'Pedro', 'Fernández', 'pedrofernandez@gmail.com');

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES (35678901, 'Laura', 'Rodríguez', 'laura.rodriguez@gmail.com');



-- ----------------------------------------------------------------------------
-- TABLA: carrera_estudiante
-- ----------------------------------------------------------------------------
INSERT INTO carrera_estudiante (carrera_id, documento_estudiante, año_ingreso, año_egreso, estado_id)
VALUES 
    (1, 40123456, '2021-03-01', NULL, 1),
    (1, 40234567, '2021-02-01', NULL, 1),
    (2, 40345678, '2022-03-01', NULL, 1),
    (2, 40456789, '2022-02-01', NULL, 1),
    (1, 40567890, '2020-03-01', NULL, 1),
    (3, 40678901, '2021-02-01', NULL, 1),
    (1, 40789012, '2023-03-01', NULL, 1),
    (2, 40890123, '2023-02-01', NULL, 1),
    (1, 35123456, '2019-03-01', NULL, 1),
    (1, 35234567, '2019-02-01', NULL, 1),
    (2, 35345678, '2019-03-01', NULL, 1),
    (2, 35456789, '2020-02-01', NULL, 1),
    (1, 35567890, '2020-03-01', NULL, 1),
    (1, 35678901, '2020-02-01', NULL, 1),
    (3, 36456789, '2018-03-01', NULL, 1),
    (3, 36345678, '2018-02-01', NULL, 1),
    (2, 36234567, '2019-02-01', NULL, 1),
    (2, 36123456, '2019-03-01', NULL, 1),
    (1, 36012345, '2020-02-01', NULL, 1),
    (1, 35901234, '2020-03-01', NULL, 1),
    (1, 35890123, '2021-02-01', NULL, 1),
    (1, 35789012, '2021-03-01', NULL, 1),
    (3, 40901234, '2022-03-01', NULL, 1),
    (3, 41012345, '2022-02-01', NULL, 1),
    (2, 41123456, '2021-03-01', NULL, 1),
    (2, 41234567, '2021-02-01', NULL, 1),
    (1, 41345678, '2020-03-01', NULL, 1),
    (1, 41456789, '2020-02-01', NULL, 1),
    (1, 41567890, '2019-03-01', NULL, 1),
    (1, 41678901, '2019-02-01', NULL, 1);

-- Ver resultado
SELECT * FROM carrera_estudiante;
GO

-- ----------------------------------------------------------------------------
-- TABLA: partido
-- ----------------------------------------------------------------------------
INSERT INTO partido (nombre_partido)
VALUES ('Lista Azul'),
       ('Lista Naranja'),
       ('Lista Blanca');

-- Ver resultado
SELECT * FROM partido;
GO

-- ----------------------------------------------------------------------------
-- TABLA: lista
-- ----------------------------------------------------------------------------
INSERT INTO lista (partido_id)
VALUES (1), -- Lista 1: Lista Azul
       (2), -- Lista 2: Lista Naranja
       (3); -- Lista 3: Lista Blanca'

-- Ver resultado
SELECT * FROM lista;
GO

-- ----------------------------------------------------------------------------
-- TABLA: cargo_eleccion
-- ----------------------------------------------------------------------------
INSERT INTO cargo_eleccion (nombre, descripcion)
VALUES ('Presidente del Centro de Estudiantes', 'Representante principal del Centro de Estudiantes'),
       ('Vicepresidente del Centro de Estudiantes', 'Segundo al mando del Centro de Estudiantes'),
       ('Secretario General del Centro de Estudiantes', 'Encargado de actas y documentación'),
       ('Tesorero del Centro de Estudiantes', 'Administrador de recursos económicos');

-- Ver resultado
SELECT * FROM cargo_eleccion;
GO

-- ----------------------------------------------------------------------------
-- TABLA: banca
-- ----------------------------------------------------------------------------
INSERT INTO banca (nombre)
VALUES ('Titular'),
       ('Suplente');

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
VALUES (1, 1, 1), -- Presidente, Banca Titular, Orden 1
       (2, 1, 1), -- Vicepresidente, Banca Titular, Orden 1
       (3, 1, 1), -- Secretario, Banca Titular, Orden 1
       (4, 1, 1), -- Tesorero, Banca Titular, Orden 1
       (3, 2, 1), -- Secretario, Banca Suplente, Orden 1
       (3, 2, 2), -- Secretario, Banca Suplente, Orden 2
       (4, 2, 1); -- Tesorero, Banca Suplente, Orden 1

-- Ver resultado
SELECT * FROM cargo_banca;
GO

-- ----------------------------------------------------------------------------
-- TABLA: cargo_banca_estudiante
-- ----------------------------------------------------------------------------
INSERT INTO cargo_banca_estudiante (cargo_id, banca_id, orden_id, documento_estudiante)
VALUES (1, 1, 1, 35123456), -- Juan Pérez - Presidente
       (2, 1, 1, 35234567), -- María González - Vicepresidente
       (3, 1, 1, 35345678), -- Carlos López - Secretario
       (4, 1, 1, 35456789), -- Ana Martínez - Tesorero Titular
       (3, 2, 1, 35567890), -- Pedro Fernández - Secretario Suplente 1
       (3, 2, 2, 35678901), -- Laura Rodríguez - Secretario Suplente 2
       (4, 2, 1, 41678901), -- Ezequiel Suárez - Tesorero Suplente

       (1, 1, 1, 41123456), -- Jazmín Romero - Presidente 
       (2, 1, 1, 41234567), -- Tomás Herrera - Vicepresidente
       (3, 1, 1, 40123456), -- Sofía García - Secretario
       (4, 1, 1, 36345678), -- Nicolás Medina - Tesorero Titular
       (3, 2, 1, 40567890), -- Camila Vega - Secretario Suplente 1
       (3, 2, 2, 40890123), -- Lucas Ortiz - Secretario Suplente 2
       (4, 2, 1, 36456789); -- Julieta Figueroa - Tesorero Suplente

-- Ver resultado
SELECT * FROM cargo_banca_estudiante;
GO

-- ----------------------------------------------------------------------------
-- TABLA: lista_cargos
-- ----------------------------------------------------------------------------
INSERT INTO lista_cargos (lista_id, cargo_id, banca_id, orden_id, documento_estudiante)
VALUES 
--Lista Azul
       (1, 1, 1, 1, 35123456), -- Juan Pérez - Presidente
       (1, 2, 1, 1, 35234567), -- María González - Vicepresidente
       (1, 3, 1, 1, 35345678), -- Carlos López - Secretario
       (1, 4, 1, 1, 35456789), -- Ana Martínez - Tesorero Titular
       (1, 3, 2, 1, 35567890), -- Pedro Fernández - Secretario Suplente 1
       (1, 3, 2, 2, 35678901), -- Laura Rodríguez - Secretario Suplente 2
       (1, 4, 2, 1, 41678901), -- Ezequiel Suárez - Tesorero Suplente
--Lista Naranja
       (2, 1, 1, 1, 41123456), -- Jazmín Romero - Presidente 
       (2, 2, 1, 1, 41234567), -- Tomás Herrera - Vicepresidente
       (2, 3, 1, 1, 40123456), -- Sofía García - Secretario
       (2, 4, 1, 1, 36345678), -- Nicolás Medina - Tesorero Titular
       (2, 3, 2, 1, 40567890), -- Camila Vega - Secretario Suplente 1
       (2, 3, 2, 2, 40890123), -- Lucas Ortiz - Secretario Suplente 2
       (2, 4, 2, 1, 36456789); -- Julieta Figueroa - Tesorero Suplente

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
INSERT INTO mesa_identificacion (nro_mesa_identificacion, eleccion_id)
VALUES (1, 1),
       (2, 1);

-- Ver resultado
SELECT * FROM mesa_identificacion;
GO

-- ----------------------------------------------------------------------------
-- TABLA: mesa_identificacion_estudiante
-- ----------------------------------------------------------------------------
INSERT INTO mesa_identificacion_estudiante (mesa_identificacion_id, documento_estudiante)
VALUES (1, 40123456),
    (1, 40234567),
    (1, 40345678),
    (1, 40456789),
    (1, 40567890),
    (1, 40678901),
    (1, 40789012),
    (1, 40890123),
    (1, 35123456),
    (1, 35234567),
    (1, 35345678),
    (1, 35456789),
    (1, 35567890),
    (1, 35678901),


    (2, 36456789),
    (2, 36345678),
    (2, 36234567),
    (2, 36123456),
    (2, 36012345),
    (2, 35901234),
    (2, 35890123),
    (2, 35789012),
    (2, 40901234),
    (2, 41012345),
    (2, 41123456),
    (2, 41234567),
    (2, 41345678),
    (2, 41456789),
    (2, 41567890),
    (2, 41678901);

-- ----------------------------------------------------------------------------
-- TABLA: mesa_votacion
-- ----------------------------------------------------------------------------
INSERT INTO mesa_votacion (nro_mesa_votacion)
VALUES (1), (2);

-- Ver resultado
SELECT * FROM mesa_votacion;
GO


select * from token_votante
-- ----------------------------------------------------------------------------
-- TABLA: token_votante
-- ----------------------------------------------------------------------------
INSERT INTO token_votante (codigo_token, mesa_identificacion_id, usado)
VALUES
    (HASHBYTES('SHA2_256', 'token1'), 1, 0),
    (HASHBYTES('SHA2_256', 'token2'), 1, 0),
    (HASHBYTES('SHA2_256', 'token3'), 1, 0),
    (HASHBYTES('SHA2_256', 'token4'), 1, 0),
    (HASHBYTES('SHA2_256', 'token5'), 1, 0),
    (HASHBYTES('SHA2_256', 'token6'), 1, 0),
    (HASHBYTES('SHA2_256', 'token7'), 1, 0),
    (HASHBYTES('SHA2_256', 'token8'), 1, 0),
    (HASHBYTES('SHA2_256', 'token9'), 1, 0),
    (HASHBYTES('SHA2_256', 'token10'), 1, 0),
    (HASHBYTES('SHA2_256', 'token11'), 1, 0),
    (HASHBYTES('SHA2_256', 'token12'), 1, 0),
    (HASHBYTES('SHA2_256', 'token13'), 1, 0),
    (HASHBYTES('SHA2_256', 'token14'), 1, 0),
    (HASHBYTES('SHA2_256', 'token15'), 1, 0),

    (HASHBYTES('SHA2_256', 'token16'), 2, 0),
    (HASHBYTES('SHA2_256', 'token17'), 2, 0),
    (HASHBYTES('SHA2_256', 'token18'), 2, 0),
    (HASHBYTES('SHA2_256', 'token19'), 2, 0),
    (HASHBYTES('SHA2_256', 'token20'), 2, 0),
    (HASHBYTES('SHA2_256', 'token21'), 2, 0),
    (HASHBYTES('SHA2_256', 'token22'), 2, 0),
    (HASHBYTES('SHA2_256', 'token23'), 2, 0),
    (HASHBYTES('SHA2_256', 'token24'), 2, 0),
    (HASHBYTES('SHA2_256', 'token25'), 2, 0),
    (HASHBYTES('SHA2_256', 'token26'), 2, 0),
    (HASHBYTES('SHA2_256', 'token27'), 2, 0),
    (HASHBYTES('SHA2_256', 'token28'), 2, 0),
    (HASHBYTES('SHA2_256', 'token29'), 2, 0),
    (HASHBYTES('SHA2_256', 'token30'), 2, 0);


    select * from voto
-- ----------------------------------------------------------------------------
-- TABLA: voto
-- ----------------------------------------------------------------------------
--NOTA: CAMBIAR EL TOKEN_ID '31' POR 1
INSERT INTO voto (token_id, lista_id, mesa_votacion_id)
VALUES
(31, 1, 1),
(2, 1, 1),
(3, 1, 1),
(4, 1, 1),
(5, 1, 1),
(6, 1, 1),
(7, 1, 1),
(8, 1, 1),
(9, 1, 1),
(10, 1, 1),
(11, 2, 1),
(12, 2, 1),
(13, 2, 1),
(14, 2, 1),
(15, 2, 2),
(16, 2, 2),
(17, 2, 2),
(18, 2, 2),
(19, 2, 2),
(20, 2, 2),
(21, 2, 2),
(22, 2, 2),
(23, 2, 2),
(24, 2, 2),
(25, 2, 2),
(26, 2, 2),
(27, 2, 2),
(28, 2, 2),
(29, 2, 2),
(30, 2, 2);

--Actualizacion de token usado
UPDATE token_votante
SET usado = 1
WHERE token_id IN (
    SELECT token_id
    FROM voto
);

INSERT INTO escrutinio_mesa (lista_id, mesa_votacion_id, cantidad_votos)
SELECT 
    lista_id,
    mesa_votacion_id,
    COUNT(*) AS cantidad_votos
FROM voto
GROUP BY 
    lista_id,
    mesa_votacion_id;

select * from escrutinio_mesa

--Resultado elección
INSERT INTO resultado_eleccion (lista_id, eleccion_id, resultado)
SELECT 
    lista_id,
    1 AS eleccion_id,
    SUM(cantidad_votos) AS resultado_total
FROM escrutinio_mesa
GROUP BY lista_id;

select * from resultado_eleccion