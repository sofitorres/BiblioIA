-- Carga de Géneros (Mínimo 5)
INSERT INTO GENERO (id_genero, nombre, descripcion) VALUES
(1, 'Fantasía', 'Mundos imaginarios, magia y criaturas épicas.'),
(2, 'Ciencia Ficción', 'Futuros tecnológicos, distopías y viajes espaciales.'),
(3, 'Policial / Noir', 'Investigación de crímenes, suspenso y drama criminal.'),
(4, 'Novela Histórica', 'Ficción basada en eventos y épocas reales del pasado.'),
(5, 'Filosofía / Ensayo', 'Tratados filosóficos, análisis sociológico y pensamiento.'),
(6, 'Realismo Mágico', 'Elementos fantásticos percibidos como parte de la normalidad.');

-- Carga de Autores (Mínimo 10)
INSERT INTO AUTOR (id_autor, nombre, apellido, nacionalidad) VALUES
(1, 'Gabriel', 'García Márquez', 'Colombiana'),
(2, 'Jorge Luis', 'Borges', 'Argentina'),
(3, 'J.R.R.', 'Tolkien', 'Británica'),
(4, 'George', 'Orwell', 'Británica'),
(5, 'Agatha', 'Christie', 'Británica'),
(6, 'Isaac', 'Asimov', 'Rusa'),
(7, 'Julio', 'Cortázar', 'Argentina'),
(8, 'Stephen', 'King', 'Estadounidense'),
(9, 'Arthur', 'Conan Doyle', 'Británica'),
(10, 'Virginia', 'Woolf', 'Británica');

-- Carga de Libros (Mínimo 20 - stock estándar inicial de 5 unidades)
INSERT INTO LIBRO (isbn, titulo, anio_publicacion, stock_total, stock_disponible) VALUES
('9780345339706', 'El Señor de los Anillos: La Comunidad del Anillo', 1954, 5, 5),
('9788420471839', 'Cien Años de Soledad', 1967, 5, 5),
('9780451524935', '1984', 1949, 5, 5),
('9788422616146', 'Asesinato en el Orient Express', 1934, 5, 5),
('9788499082479', 'Fundación', 1951, 5, 5),
('9788420659404', 'Ficciones', 1944, 5, 5),
('9788466331906', 'Rayuela', 1963, 5, 5),
('9788401352836', 'El Resplandor', 1977, 5, 5),
('9788420665429', 'Estudio en Escarlata', 1887, 5, 5),
('9788420654010', 'Al Faro', 1927, 5, 5),
('9780261103252', 'El Hobbit', 1937, 5, 5),
('9780451526342', 'Rebelión en la Granja', 1945, 5, 5),
('9788497592420', 'Crónica de una Muerte Anunciada', 1981, 5, 5),
('9788422615439', 'Muerte en el Nilo', 1937, 5, 5),
('9788499082486', 'Fundación e Imperio', 1952, 5, 5),
('9788420633114', 'El Aleph', 1949, 5, 5),
('9788466329439', 'It', 1986, 5, 5),
('9788420665436', 'El Sabueso de los Baskerville', 1902, 5, 5),
('9788423351234', 'Bestiario', 1951, 5, 5),
('9788401341234', 'Misery', 1987, 5, 5);

-- Relaciones Libro - Autor (N:M)
INSERT INTO LIBRO_AUTOR (isbn, id_autor) VALUES 
('9780345339706', 3), ('9788420471839', 1), ('9780451524935', 4), ('9788422616146', 5),
('9788499082479', 6), ('9788420659404', 2), ('9788466331906', 7), ('9788401352836', 8),
('9788420665429', 9), ('9788420654010', 10), ('9780261103252', 3), ('9780451526342', 4),
('9788497592420', 10), ('9788422615439', 5), ('9788499082486', 6), ('9788420633114', 2),
('9788466329439', 8), ('9788420665436', 9), ('9788423351234', 7), ('9788401341234', 8);

-- Relaciones Libro - Género (N:M)
INSERT INTO LIBRO_GENERO (isbn, id_genero) VALUES 
('9780345339706', 1), ('9788420471839', 6), ('9780451524935', 2), ('9788422616146', 3),
('9788499082479', 2), ('9788420659404', 5), ('9788466331906', 6), ('9788401352836', 1),
('9788420665429', 3), ('9788420654010', 5), ('9780261103252', 1), ('9780451526342', 2),
('9788497592420', 6), ('9788422615439', 3), ('9788499082486', 2), ('9788420633114', 5),
('9788466329439', 1), ('9788420665436', 3), ('9788423351234', 6), ('9788401341234', 1);

-- Carga de Ejemplares (Instancias físicas)
INSERT INTO EJEMPLAR (id_ejemplar, isbn, nro_ejemplar, estado_fisico) VALUES
(1, '9780345339706', 1, 'ACTIVO'),  (2, '9780345339706', 2, 'REGULAR'),
(3, '9788420471839', 1, 'ACTIVO'),  (4, '9788420471839', 2, 'ACTIVO'),
(5, '9780451524935', 1, 'ACTIVO'),  (6, '9780451524935', 2, 'ACTIVO'),
(7, '9788422616146', 1, 'ACTIVO'),  (8, '9788422616146', 2, 'BAJA'),
(9, '9788499082479', 1, 'ACTIVO'),  (10, '9788499082479', 2, 'ACTIVO'),
(11, '9788420659404', 1, 'ACTIVO'), (12, '9788420659404', 2, 'ACTIVO'),
(13, '9788466331906', 1, 'ACTIVO'), (14, '9788466331906', 2, 'ACTIVO'),
(15, '9788401352836', 1, 'ACTIVO'), (16, '9788401352836', 2, 'REGULAR'),
(17, '9788420665429', 1, 'ACTIVO'), (18, '9788420665429', 2, 'ACTIVO'),
(19, '9788420654010', 1, 'ACTIVO'), (20, '9788420654010', 2, 'ACTIVO'),
(21, '9780261103252', 1, 'ACTIVO'), (22, '9780261103252', 2, 'ACTIVO'),
(23, '9780451526342', 1, 'ACTIVO'), (24, '9780451526342', 2, 'ACTIVO'),
(25, '9788497592420', 1, 'ACTIVO'), (26, '9788497592420', 2, 'ACTIVO'),
(27, '9788422615439', 1, 'ACTIVO'), (28, '9788422615439', 2, 'ACTIVO'),
(29, '9788499082486', 1, 'ACTIVO'), (30, '9788499082486', 2, 'ACTIVO'),
(31, '9788420633114', 1, 'ACTIVO'), (32, '9788420633114', 2, 'ACTIVO'),
(33, '9788466329439', 1, 'ACTIVO'), (34, '9788466329439', 2, 'ACTIVO'),
(35, '9788420665436', 1, 'ACTIVO'), (36, '9788420665436', 2, 'ACTIVO'),
(37, '9788423351234', 1, 'ACTIVO'), (38, '9788423351234', 2, 'ACTIVO'),
(39, '9788401341234', 1, 'ACTIVO'), (40, '9788401341234', 2, 'ACTIVO');

-- Carga de Socios (Mínimo 30 - Corrección: Se agregaron IDs 1 y 2 para evitar fallos de FK)
INSERT INTO SOCIO (id_socio, dni, nombre, apellido, email, fecha_alta, estado) VALUES
(1, '35000001', 'Carlos', 'Pérez', 'carlos01@email.com', '2025-01-10', 'ACTIVO'),
(2, '35000002', 'María', 'García', 'maria02@email.com', '2025-01-12', 'ACTIVO'),
(3, '35000003', 'Juan', 'Martínez', 'juan03@email.com', '2025-01-15', 'ACTIVO'),
(4, '35000004', 'Ana', 'Rodríguez', 'ana04@email.com', '2025-01-20', 'SUSPENDIDO'),
(5, '35000005', 'Luis', 'López', 'luis05@email.com', '2025-01-22', 'ACTIVO'),
(6, '35000006', 'Florencia', 'Gómez', 'flor06@email.com', '2025-01-25', 'ACTIVO'),
(7, '35000007', 'Diego', 'Díaz', 'diego07@email.com', '2025-01-28', 'ACTIVO'),
(8, '35000008', 'Lucía', 'Álvarez', 'lucia08@email.com', '2025-02-01', 'ACTIVO'),
(9, '35000009', 'Andrés', 'Romero', 'andres09@email.com', '2025-02-03', 'ACTIVO'),
(10, '35000010', 'Sofia', 'Sosa', 'sofia10@email.com', '2025-02-05', 'SUSPENDIDO'),
(11, '35000011', 'Martin', 'Torres', 'martin11@email.com', '2025-02-10', 'ACTIVO'),
(12, '35000012', 'Elena', 'Benítez', 'elena12@email.com', '2025-02-12', 'ACTIVO'),
(13, '35000013', 'Ricardo', 'Ramírez', 'ricardo13@email.com', '2025-02-15', 'ACTIVO'),
(14, '35000014', 'Laura', 'Ruiz', 'laura14@email.com', '2025-02-18', 'ACTIVO'),
(15, '35000015', 'Gabriel', 'Medina', 'gabriel15@email.com', '2025-02-20', 'ACTIVO'),
(16, '35000016', 'Camila', 'Herrera', 'camila16@email.com', '2025-02-22', 'ACTIVO'),
(17, '35000017', 'Javier', 'Castro', 'javier17@email.com', '2025-02-25', 'ACTIVO'),
(18, '35000018', 'Valeria', 'Peña', 'valeria18@email.com', '2025-02-28', 'ACTIVO'),
(19, '35000019', 'Alejandro', 'Blanco', 'ale19@email.com', '2025-03-01', 'ACTIVO'),
(20, '35000020', 'Micaela', 'Morales', 'mica20@email.com', '2025-03-03', 'ACTIVO'),
(21, '35000021', 'Lucas', 'Ortega', 'lucas21@email.com', '2025-03-05', 'ACTIVO'),
(22, '35000022', 'Agustina', 'Delgado', 'agus22@email.com', '2025-03-08', 'ACTIVO'),
(23, '35000023', 'Nicolas', 'Morínigo', 'nico23@email.com', '2025-03-10', 'ACTIVO'),
(24, '35000024', 'Julia', 'Acosta', 'julia24@email.com', '2025-03-12', 'ACTIVO'),
(25, '35000025', 'Tomas', 'Ríos', 'tomas25@email.com', '2025-03-15', 'ACTIVO'),
(26, '35000026', 'Paulina', 'Suárez', 'pau26@email.com', '2025-03-18', 'ACTIVO'),
(27, '35000027', 'Mariano', 'Cáceres', 'mariano27@email.com', '2025-03-20', 'ACTIVO'),
(28, '35000028', 'Belen', 'Maldonado', 'belen28@email.com', '2025-03-22', 'ACTIVO'),
(29, '35000029', 'Facundo', 'Páez', 'facu29@email.com', '2025-03-25', 'ACTIVO'),
(30, '35000030', 'Victoria', 'Giménez', 'vic30@email.com', '2025-03-28', 'ACTIVO');

-- Carga de Sanciones iniciales
INSERT INTO SANCION (id_sancion, id_socio, tipo, fecha_inicio, fecha_fin, motivo) VALUES
(1, 4, 'SUSPENSIÓN POR MORA', '2026-06-01', '2026-07-01', 'Retraso de 10 días en la devolución del ejemplar ID 2.'),
(2, 10, 'SUSPENSIÓN POR DAÑO', '2026-06-10', '2026-08-10', 'Ejemplar devuelto con roturas graves en las páginas.');

-- Mix exacto de Préstamos (Mínimo 50 en total)
-- A) 36 HISTÓRICOS DEVUELTOS
INSERT INTO PRESTAMO (id_prestamo, id_socio, id_ejemplar, fecha_prestamo, fecha_vencimiento, fecha_devolucion, estado) VALUES
(1,1,1,'2026-01-02','2026-01-16','2026-01-15','DEVUELTO'),   (2,2,3,'2026-01-03','2026-01-17','2026-01-17','DEVUELTO'),
(3,3,5,'2026-01-05','2026-01-19','2026-01-18','DEVUELTO'),   (4,5,7,'2026-01-10','2026-01-24','2026-01-22','DEVUELTO'),
(5,6,9,'2026-01-12','2026-01-26','2026-01-26','DEVUELTO'),   (6,7,11,'2026-01-15','2026-01-29','2026-01-28','DEVUELTO'),
(7,8,13,'2026-01-20','2026-02-03','2026-02-01','DEVUELTO'),  (8,9,15,'2026-01-22','2026-02-05','2026-02-05','DEVUELTO'),
(9,11,17,'2026-01-25','2026-02-08','2026-02-07','DEVUELTO'), (10,12,19,'2026-01-28','2026-02-11','2026-02-10','DEVUELTO'),
(11,13,21,'2026-02-01','2026-02-15','2026-02-15','DEVUELTO'), (12,14,23,'2026-02-02','2026-02-16','2026-02-14','DEVUELTO'),
(13,15,25,'2026-02-05','2026-02-19','2026-02-19','DEVUELTO'), (14,16,27,'2026-02-08','2026-02-22','2026-02-20','DEVUELTO'),
(15,17,29,'2026-02-10','2026-02-24','2026-02-24','DEVUELTO'), (16,18,31,'2026-02-12','2026-02-26','2026-02-25','DEVUELTO'),
(17,19,33,'2026-02-15','2026-03-01','2026-02-28','DEVUELTO'), (18,20,35,'2026-02-18','2026-03-04','2026-03-04','DEVUELTO'),
(19,21,37,'2026-02-20','2026-03-06','2026-03-05','DEVUELTO'), (20,22,39,'2026-02-22','2026-03-08','2026-03-08','DEVUELTO'),
(21,23,2,'2026-03-01','2026-03-15','2026-03-14','DEVUELTO'),  (22,24,4,'2026-03-03','2026-03-17','2026-03-17','DEVUELTO'),
(23,25,6,'2026-03-05','2026-03-19','2026-03-18','DEVUELTO'),  (24,26,10,'2026-03-10','2026-03-24','2026-03-24','DEVUELTO'),
(25,27,12,'2026-03-12','2026-03-26','2026-03-25','DEVUELTO'), (26,28,14,'2026-03-15','2026-03-29','2026-03-29','DEVUELTO'),
(27,29,16,'2026-03-20','2026-04-03','2026-04-02','DEVUELTO'), (28,30,18,'2026-03-22','2026-04-05','2026-04-05','DEVUELTO'),
(29,1,20,'2026-04-01','2026-04-15','2026-04-14','DEVUELTO'),  (30,2,22,'2026-04-03','2026-04-17','2026-04-17','DEVUELTO'),
(31,3,24,'2026-04-05','2026-04-19','2026-04-18','DEVUELTO'),  (32,5,26,'2026-04-10','2026-04-24','2026-04-23','DEVUELTO'),
(33,6,28,'2026-04-12','2026-04-26','2026-04-26','DEVUELTO'),  (34,7,30,'2026-04-15','2026-04-29','2026-04-29','DEVUELTO'),
(35,8,32,'2026-04-20','2026-05-04','2026-05-03','DEVUELTO'),  (36,9,34,'2026-04-22','2026-05-06','2026-05-06','DEVUELTO');

-- B) 10 PRÉSTAMOS ACTIVOS EN VIGENCIA (Vencen a fin de mes)
INSERT INTO PRESTAMO (id_prestamo, id_socio, id_ejemplar, fecha_prestamo, fecha_vencimiento, fecha_devolucion, estado) VALUES
(37,11,1,'2026-06-15','2026-06-29',NULL,'ACTIVO'),  (38,12,3,'2026-06-15','2026-06-29',NULL,'ACTIVO'),
(39,13,5,'2026-06-16','2026-06-30',NULL,'ACTIVO'),  (40,14,9,'2026-06-16','2026-06-30',NULL,'ACTIVO'),
(41,15,11,'2026-06-17','2026-07-01',NULL,'ACTIVO'), (42,16,13,'2026-06-17','2026-07-01',NULL,'ACTIVO'),
(43,17,15,'2026-06-18','2026-07-02',NULL,'ACTIVO'), (44,18,17,'2026-06-18','2026-07-02',NULL,'ACTIVO'),
(45,19,19,'2026-06-19','2026-07-03',NULL,'ACTIVO'), (46,20,21,'2026-06-19','2026-07-03',NULL,'ACTIVO');

-- C) 6 PRÉSTAMOS VENCIDOS MANUALES (Su vencimiento ya pasó)
INSERT INTO PRESTAMO (id_prestamo, id_socio, id_ejemplar, fecha_prestamo, fecha_vencimiento, fecha_devolucion, estado) VALUES
(47,21,23,'2026-05-01','2026-05-15',NULL,'ACTIVO'), (48,22,25,'2026-05-02','2026-05-16',NULL,'ACTIVO'),
(49,23,27,'2026-05-03','2026-05-17',NULL,'ACTIVO'), (50,24,29,'2026-05-04','2026-05-18',NULL,'ACTIVO'),
(51,25,31,'2026-05-05','2026-05-19',NULL,'ACTIVO'), (52,26,33,'2026-05-06','2026-05-20',NULL,'ACTIVO');

-- Sincronización del stock inicial con los 16 préstamos activos estáticos cargados arriba
UPDATE LIBRO SET stock_disponible = 4 WHERE isbn IN (
    '9780345339706', '9788420471839', '9780451524935', '9788499082479', 
    '9788420659404', '9788466331906', '9788401352836', '9788420665429', 
    '9788420654010', '9780261103252', '9780451526342', '9788497592420', 
    '9788422615439', '9788499082486', '9788420633114', '9788466329439'
);

-- Verificaciones rápidas de integridad de negocio
SELECT titulo, stock_disponible FROM LIBRO WHERE isbn = '9780451524935';
SELECT * FROM AUDITORIA_PRESTAMOS;

-- Prueba de Renovación en término (Préstamo activo 37 de la carga de prueba)
CALL sp_renovar_prestamo(37);
SELECT * FROM AUDITORIA_PRESTAMOS WHERE id_prestamo = 37;
-- Socio suspendido que intenta realizar un prestamo
call sp_registrar_prestamo(4,2);