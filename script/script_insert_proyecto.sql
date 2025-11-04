-- SCRIPT "nombre del proyecto"
-- INSERCIÓN DEL LOTE DE DATOS

USE proyecto_elecciones;
GO

        --/ UNIVERSIDAD /--
INSERT INTO universidad (nombre)
VALUES ('Universidad Nacional del Nordeste');


        --/ FACULTAD /--
INSERT INTO facultad (universidad_id, nombre_facultad, direccion)
VALUES (1,'Facultad de Ciencias Exactas y Naturales y Agrimensura', '9 de Julio 1449 - Corrientes, Corrientes');


        --/ CARRERA /--
INSERT INTO carrera (nombre_carrera)
VALUES ('Licenciatura en Sistemas'),
       ('Agrimensura');


       --/ FACULTAD_CARRERA /--
INSERT INTO facultad_carrera (universidad_id, facultad_id, carrera_id)
VALUES 
(1, 2, 1),
(1, 2, 2);


        --/ PARTIDO /--
INSERT INTO partido (nombre_partido)
VALUES ('Lista Azul'),
       ('Lista Naranja');


        --/ ESTADO CARRERA /--
INSERT INTO estado_carrera (nombre)
VALUES ('Regular'),
       ('Egresado/a'),
       ('Libre');


        --/ ESTUDIANTES /--
INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES
(43116282,'Gabriela Antonella','Montanaro','gabrielaMontanaro@gmail.com'),
(43068676,'Bianca Ailin','Isasi Vitale','biancaIsasiVitale@gmail.com'),
(46382175,'Nicolas Alejandro','Pucheta Blanco','NicolasPucheta@gmail.com'),
(45095896,'Axel','Silva Riquelme','AxelSilva@gmail.com')

INSERT INTO estudiante (documento_estudiante, nombre, apellido, email)
VALUES 
(12345678, 'María', 'Gómez', 'maria.gomez@gmail.com'),
(87654321, 'Pedro', 'Leyes', 'pedro.leyes@gmail.com'),
(33445566, 'Ana', 'Martínez', 'ana.martinez@gmail.com');


        --/ CARRERA ESTUDIANTE /--
INSERT INTO carrera_estudiante (carrera_id, documento_estudiante, año_ingreso, estado_id)
VALUES 
(1,43116282,'2022-02-15',1),
(1,43068676,'2022-02-15',1),
(1,46382175,'2022-02-15',1),
(1,45095896,'2022-02-15',1),
(1, 12345678, '2021-03-10', 1),
(1, 87654321, '2020-03-10', 1),
(2, 33445566, '2019-03-10', 1);


       --/ CARGO ELECCION /--
INSERT INTO cargo_eleccion (nombre, descripcion)
VALUES 
('Presidente del Centro de Estudiantes', 'Máximo cargo de representación estudiantil'),
('Vicepresidente', 'Segundo cargo de mayor jerarquía'),
('Secretario General', 'Responsable de la gestión administrativa del centro');


       --/ BANCA /--
INSERT INTO banca (nombre)
VALUES 
('Titular'),
('Suplente');


       --/ ORDEN /--
INSERT INTO orden (numero)
VALUES 
(1),
(2),
(3);


       --/ CARGO BANCA /--
INSERT INTO cargo_banca (cargo_id, banca_id, orden_id)
VALUES
(1, 1, 1),  -- Presidente Titular
(1, 2, 2),  -- Presidente Suplente
(2, 1, 1),  -- Vicepresidente Titular
(2, 2, 2),  -- Vicepresidente Suplente
(3, 1, 1);  -- Secretario General Titular

select * from cargo_banca


       --/ CARGO BANCA BANCA /--
INSERT INTO cargo_banca_estudiante (cargo_id, banca_id, orden_id, documento_estudiante)
VALUES
(1, 1, 1, 43116282), -- Gabriela Presidente Titular
(1, 2, 2, 43068676), -- Bianca Presidente Suplente
(2, 1, 1, 46382175), -- Nicolás Vicepresidente Titular
(2, 2, 2, 45095896), -- Axel Vicepresidente Suplente
(3, 1, 1, 12345678); -- María Secretaria General Titular


       --/ LISTA /--
INSERT INTO lista (partido_id)
VALUES
(1), -- Lista Azul
(2); -- Lista Naranja


       --/ LISTA CARGOS/--
INSERT INTO lista_cargos (lista_id, cargo_id, banca_id, orden_id, documento_estudiante)
VALUES
(1, 1, 1, 1, 43116282),
(1, 2, 1, 1, 46382175),
(1, 3, 1, 1, 12345678),
(2, 1, 2, 2, 43068676),
(2, 2, 2, 2, 45095896);


       --/ ELECCION /--
INSERT INTO eleccion (año)
VALUES (2025);


       --/ MESA IDENTIFICACION /--
INSERT INTO mesa_identificacion (nro_mesa_identificacion, eleccion_id)
VALUES 
(1, 1),
(2, 1);


       --/ MESA IDENTIFICACION ESTUDIANTE /--
INSERT INTO mesa_identificacion_estudiante (mesa_identificacion_id, documento_estudiante)
VALUES
(1, 43116282),
(1, 43068676),
(1, 46382175),
(2, 45095896),
(2, 12345678),
(2, 87654321),
(2, 33445566);


       --/ TOKEN VOTANTE /--
INSERT INTO token_votante (codigo_token, mesa_identificacion_id, usado)
VALUES
(HASHBYTES('SHA2_256', 'token1'), 1, 0),
(HASHBYTES('SHA2_256', 'token2'), 1, 0),
(HASHBYTES('SHA2_256', 'token3'), 1, 0),
(HASHBYTES('SHA2_256', 'token4'), 2, 0),
(HASHBYTES('SHA2_256', 'token5'), 2, 0),
(HASHBYTES('SHA2_256', 'token6'), 2, 0),
(HASHBYTES('SHA2_256', 'token7'), 2, 0);

select * from token_votante


       --/ MESA VOTACION /--
INSERT INTO mesa_votacion (nro_mesa_votacion)
VALUES 
(1),
(2);


       --/ MESA VOTACION TOKEN /--
INSERT INTO mesa_votacion_token (mesa_votacion_id, token_id)
VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(2, 6),
(2, 7);


       --/ VOTO /--
INSERT INTO voto (token_id, lista_id)
VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 1),
(6, 2),
(7, 1);


       --/ ESCRUTINIO MESA /--
INSERT INTO escrutinio_mesa (lista_id, mesa_votacion_id, cantidad_votos)
VALUES
(1, 1, 2),
(2, 1, 1),
(1, 2, 2),
(2, 2, 2);


       --/ RESULTADO ELECCION /--
INSERT INTO resultado_eleccion (lista_id, eleccion_id, resultado)
VALUES
(1, 1, 4),
(2, 1, 3);
select * from resultado_eleccion


       --/ CONSULTA PRUEBA /--
SELECT l.lista_id, p.nombre_partido, COUNT(v.token_id) AS votos
FROM voto v
JOIN lista l ON v.lista_id = l.lista_id
JOIN partido p ON l.partido_id = p.partido_id
GROUP BY l.lista_id, p.nombre_partido;

