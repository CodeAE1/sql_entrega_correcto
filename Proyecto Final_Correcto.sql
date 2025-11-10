-- -----------------------------------------------------
-- Creación del esquema
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS biblioteca;
CREATE SCHEMA IF NOT EXISTS biblioteca;
USE biblioteca;

-- -----------------------------------------------------
-- Tabla para géneros literarios
-- -----------------------------------------------------
CREATE TABLE Generos (
  id_genero INT NOT NULL AUTO_INCREMENT,
  nombre_genero VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_genero)
);

-- -----------------------------------------------------
-- Tabla para categorías temáticas
-- -----------------------------------------------------
CREATE TABLE Categorias (
  id_categoria INT NOT NULL AUTO_INCREMENT,
  nombre_categoria VARCHAR(50) NOT NULL,
  descripcion TEXT,
  PRIMARY KEY (id_categoria)
);

-- -----------------------------------------------------
-- Tabla para tipos de usuario
-- -----------------------------------------------------
CREATE TABLE TiposUsuario (
  id_tipo_usuario INT NOT NULL AUTO_INCREMENT,
  nombre_tipo VARCHAR(50) NOT NULL,
  prestamos_maximos INT NOT NULL,
  dias_prestamo INT NOT NULL,
  PRIMARY KEY (id_tipo_usuario)
);

-- -----------------------------------------------------
-- Tabla para sedes de la biblioteca
-- -----------------------------------------------------
CREATE TABLE Sedes (
  id_sede INT NOT NULL AUTO_INCREMENT,
  nombre_sede VARCHAR(100) NOT NULL,
  direccion VARCHAR(255) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_sede)
);

-- -----------------------------------------------------
-- Tabla para los autores
-- -----------------------------------------------------
CREATE TABLE Autores (
  id_autor INT NOT NULL AUTO_INCREMENT,
  nombre_autor VARCHAR(100) NOT NULL,
  apellido_autor VARCHAR(100) NOT NULL,
  nacionalidad VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_autor)
);

-- -----------------------------------------------------
-- Tabla para las editoriales
-- -----------------------------------------------------
CREATE TABLE Editoriales (
  id_editorial INT NOT NULL AUTO_INCREMENT,
  nombre_editorial VARCHAR(100) NOT NULL,
  ciudad_editorial VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_editorial)
);

-- -----------------------------------------------------
-- Tabla para los libros
-- -----------------------------------------------------
CREATE TABLE Libros (
  id_libro INT NOT NULL AUTO_INCREMENT,
  titulo VARCHAR(255) NOT NULL,
  fecha_publicacion DATE NOT NULL,
  id_genero INT NOT NULL,
  id_categoria INT NOT NULL,
  disponibilidad BOOLEAN NOT NULL,
  id_editorial INT NOT NULL,
  PRIMARY KEY (id_libro),
  FOREIGN KEY (id_genero) REFERENCES Generos (id_genero),
  FOREIGN KEY (id_categoria) REFERENCES Categorias (id_categoria),
  FOREIGN KEY (id_editorial) REFERENCES Editoriales (id_editorial)
);

-- -----------------------------------------------------
-- Tabla para los usuarios (lectores)
-- -----------------------------------------------------
CREATE TABLE Usuarios (
  id_usuario INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  direccion VARCHAR(255) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  correo_electronico VARCHAR(100) NOT NULL,
  id_tipo_usuario INT NOT NULL,
  PRIMARY KEY (id_usuario),
  FOREIGN KEY (id_tipo_usuario) REFERENCES TiposUsuario (id_tipo_usuario)
);

-- -----------------------------------------------------
-- Tabla de unión para la relación muchos a muchos entre autores y libros
-- -----------------------------------------------------
CREATE TABLE Autores_Libros (
  id_autor_libro INT NOT NULL AUTO_INCREMENT,
  id_autor INT NOT NULL,
  id_libro INT NOT NULL,
  PRIMARY KEY (id_autor_libro),
  FOREIGN KEY (id_autor) REFERENCES Autores (id_autor),
  FOREIGN KEY (id_libro) REFERENCES Libros (id_libro)
);

-- -----------------------------------------------------
-- Tabla para ejemplares de libros
-- -----------------------------------------------------
CREATE TABLE Ejemplares (
  id_ejemplar INT NOT NULL AUTO_INCREMENT,
  id_libro INT NOT NULL,
  id_sede INT NOT NULL,
  ubicacion VARCHAR(100),
  estado VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_ejemplar),
  FOREIGN KEY (id_libro) REFERENCES Libros (id_libro),
  FOREIGN KEY (id_sede) REFERENCES Sedes (id_sede)
);

-- -----------------------------------------------------
-- Tabla para los préstamos de libros
-- -----------------------------------------------------
CREATE TABLE Prestamos (
  id_prestamo INT NOT NULL AUTO_INCREMENT,
  fecha_prestamo DATE NOT NULL,
  fecha_devolucion_estimada DATE NOT NULL,
  fecha_devolucion_real DATE,
  estado_prestamo VARCHAR(20) NOT NULL,
  id_usuario INT NOT NULL,
  id_libro INT NOT NULL,
  id_sede INT NOT NULL,
  PRIMARY KEY (id_prestamo),
  FOREIGN KEY (id_usuario) REFERENCES Usuarios (id_usuario),
  FOREIGN KEY (id_libro) REFERENCES Libros (id_libro),
  FOREIGN KEY (id_sede) REFERENCES Sedes (id_sede)
);

-- -----------------------------------------------------
-- Tabla para devoluciones
-- -----------------------------------------------------
CREATE TABLE Devoluciones (
  id_devolucion INT NOT NULL AUTO_INCREMENT,
  id_prestamo INT NOT NULL,
  fecha_devolucion DATE NOT NULL,
  multa_aplicada DECIMAL(10, 2) DEFAULT 0.00,
  observaciones TEXT,
  PRIMARY KEY (id_devolucion),
  FOREIGN KEY (id_prestamo) REFERENCES Prestamos (id_prestamo)
);

-- -----------------------------------------------------
-- Tabla para multas
-- -----------------------------------------------------
CREATE TABLE Multas (
  id_multa INT NOT NULL AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  monto DECIMAL(10, 2) NOT NULL,
  fecha_aplicacion DATE NOT NULL,
  pagada BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (id_multa),
  FOREIGN KEY (id_usuario) REFERENCES Usuarios (id_usuario)
);

-- -----------------------------------------------------
-- Tabla para reservas
-- -----------------------------------------------------
CREATE TABLE Reservas (
  id_reserva INT NOT NULL AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  id_libro INT NOT NULL,
  fecha_reserva DATE NOT NULL,
  estado VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_reserva),
  FOREIGN KEY (id_usuario) REFERENCES Usuarios (id_usuario),
  FOREIGN KEY (id_libro) REFERENCES Libros (id_libro)
);

-- -----------------------------------------------------
-- Tabla de hechos: Historial de préstamos
-- -----------------------------------------------------
CREATE TABLE HistorialPrestamos (
  id_registro INT NOT NULL AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  id_libro INT NOT NULL,
  id_prestamo INT NOT NULL,
  dias_retraso INT DEFAULT 0,
  multa_generada DECIMAL(10, 2) DEFAULT 0.00,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE,
  PRIMARY KEY (id_registro),
  FOREIGN KEY (id_usuario) REFERENCES Usuarios (id_usuario),
  FOREIGN KEY (id_libro) REFERENCES Libros (id_libro),
  FOREIGN KEY (id_prestamo) REFERENCES Prestamos (id_prestamo)
);

-- -----------------------------------------------------
-- Inserción de datos en Generos (5 registros)
-- -----------------------------------------------------
INSERT INTO Generos (nombre_genero) VALUES
('Ficcion'), ('Realismo Magico'), ('Novela'), ('Poesia'), ('Ensayo');

-- -----------------------------------------------------
-- Inserción de datos en Categorias (5 registros)
-- -----------------------------------------------------
INSERT INTO Categorias (nombre_categoria, descripcion) VALUES
('Literatura', 'Libros de ficcion y no ficcion'),
('Ciencia', 'Libros de ciencia y tecnologia'),
('Infantil', 'Libros para niños'),
('Historia', 'Libros de historia'),
('Biografia', 'Biografias de personajes importantes');

-- -----------------------------------------------------
-- Inserción de datos en TiposUsuario (3 registros)
-- -----------------------------------------------------
INSERT INTO TiposUsuario (nombre_tipo, prestamos_maximos, dias_prestamo) VALUES
('Estudiante', 3, 14),
('Docente', 5, 30),
('Invitado', 1, 7);

-- -----------------------------------------------------
-- Inserción de datos en Sedes (3 registros)
-- -----------------------------------------------------
INSERT INTO Sedes (nombre_sede, direccion, telefono) VALUES
('Sede Central', 'Calle Principal 123', '123456789'),
('Sede Norte', 'Avenida Norte 456', '987654321'),
('Sede Sur', 'Calle Sur 789', '456789123');

-- -----------------------------------------------------
-- Inserción de datos en Autores (20 registros)
-- -----------------------------------------------------
INSERT INTO Autores (nombre_autor, apellido_autor, nacionalidad) VALUES
('Miguel', 'de Cervantes', 'Espanola'),
('Gabriel', 'Garcia Marquez', 'Colombiana'),
('Isabel', 'Allende', 'Chilena'),
('Jorge Luis', 'Borges', 'Argentina'),
('Mario', 'Vargas Llosa', 'Peruana'),
('Pablo', 'Neruda', 'Chilena'),
('Octavio', 'Paz', 'Mexicana'),
('Clarice', 'Lispector', 'Brasileña'),
('Julio', 'Cortazar', 'Argentina'),
('Laura', 'Esquivel', 'Mexicana'),
('Juan Rulfo', 'Gonzalez', 'Mexicana'),
('Carlos Fuentes', 'Macias', 'Mexicana'),
('Mario Benedetti', 'Moraes', 'Uruguaya'),
('Antonio', 'Skarmeta', 'Chilena'),
('Roberto', 'Bolano', 'Chilena'),
('Paulo', 'Coelho', 'Brasileña'),
('Luisa', 'Valenzuela', 'Argentina'),
('Eduardo', 'Galeano', 'Uruguaya'),
('Fernando', 'Pessoa', 'Portuguesa'),
('Jose Saramago', 'de Carvalho', 'Portuguesa');

-- -----------------------------------------------------
-- Inserción de datos en Editoriales (20 registros)
-- -----------------------------------------------------
INSERT INTO Editoriales (nombre_editorial, ciudad_editorial) VALUES
('Planeta', 'Madrid'),
('Santillana', 'Buenos Aires'),
('Penguin Random House', 'Mexico'),
('Alfaguara', 'Madrid'),
('Anaya', 'Madrid'),
('McGraw-Hill', 'Bogota'),
('Norma', 'Bogota'),
('Sudamericana', 'Buenos Aires'),
('Fondo de Cultura Economica', 'Mexico'),
('Tusquets', 'Barcelona'),
('Ediciones B', 'Barcelona'),
('Galaxia Gutenberg', 'Barcelona'),
('Siruela', 'Madrid'),
('Kairos', 'Barcelona'),
('Pre-Textos', 'Valencia'),
('Acantilado', 'Barcelona'),
('Visor', 'Madrid'),
('Renacimiento', 'Sevilla'),
('Iberoamericana Vervuert', 'Madrid'),
('Editorial Universidad de Guadalajara', 'Guadalajara');

-- -----------------------------------------------------
-- Inserción de datos en Libros (20 registros)
-- -----------------------------------------------------
INSERT INTO Libros (titulo, fecha_publicacion, id_genero, id_categoria, disponibilidad, id_editorial) VALUES
('Don Quijote de la Mancha', '1605-01-16', 3, 1, true, 1),
('Cien anos de soledad', '1967-05-30', 2, 1, true, 2),
('La casa de los espiritus', '1982-09-17', 2, 1, false, 3),
('Ficciones', '1944-01-01', 1, 1, true, 4),
('La ciudad y los perros', '1963-01-01', 3, 1, true, 5),
('Veinte poemas de amor y una cancion desesperada', '1924-01-01', 4, 1, true, 6),
('El laberinto de la soledad', '1950-01-01', 5, 1, true, 7),
('La pasion segun G.H.', '1964-01-01', 3, 1, false, 8),
('Rayuela', '1963-06-28', 3, 1, true, 9),
('Como agua para chocolate', '1989-01-01', 3, 1, true, 10),
('Pedro Paramo', '1955-01-01', 3, 1, true, 11),
('La muerte de Artemio Cruz', '1962-01-01', 3, 1, true, 12),
('La tregua', '1960-01-01', 3, 1, true, 13),
('La historia oficial', '1985-01-01', 1, 1, true, 14),
('2666', '2004-01-01', 3, 1, true, 15),
('El alquimista', '1988-01-01', 1, 1, true, 16),
('La casa de Adela', '1993-01-01', 3, 1, true, 17),
('El libro de los abrazos', '1989-01-01', 5, 1, true, 18),
('El nombre de la rosa', '1980-01-01', 3, 1, true, 19),
('Memorial del engano', '1992-01-01', 3, 1, true, 20);

-- -----------------------------------------------------
-- Inserción de datos en Usuarios (20 registros)
-- -----------------------------------------------------
INSERT INTO Usuarios (nombre, apellido, direccion, telefono, correo_electronico, id_tipo_usuario) VALUES
('Ana', 'Gomez', 'Calle 123', '123456789', 'ana@example.com', 1),
('Luis', 'Perez', 'Avenida Siempre Viva 742', '987654321', 'luis@example.com', 1),
('Maria', 'Rodriguez', 'Carrera 45 #12-34', '456789123', 'maria@example.com', 2),
('Carlos', 'Lopez', 'Calle 8 #10-20', '321654987', 'carlos@example.com', 2),
('Sofia', 'Martinez', 'Calle 9 #11-15', '654987321', 'sofia@example.com', 1),
('Andres', 'Hernandez', 'Diagonal 50 #20-10', '789123456', 'andres@example.com', 1),
('Valentina', 'Diaz', 'Transversal 30 #40-50', '147258369', 'valentina@example.com', 1),
('Sebastian', 'Ruiz', 'Calle 25 #35-45', '258369147', 'sebastian@example.com', 1),
('Camila', 'Jimenez', 'Avenida 68 #78-89', '369147258', 'camila@example.com', 1),
('Daniel', 'Torres', 'Carrera 15 #25-35', '159357486', 'daniel@example.com', 1),
('Fernanda', 'Silva', 'Calle 100 #200-300', '123987456', 'fernanda@example.com', 1),
('Pedro', 'Garcia', 'Avenida Central 500', '456123789', 'pedro@example.com', 2),
('Lucia', 'Mendoza', 'Calle Luna 45', '789456123', 'lucia@example.com', 1),
('Diego', 'Castro', 'Carrera 30 #40-50', '321789456', 'diego@example.com', 1),
('Paula', 'Rojas', 'Calle Sol 12', '654321987', 'paula@example.com', 1),
('Javier', 'Flores', 'Diagonal 100 #200', '987654321', 'javier@example.com', 1),
('Sara', 'Romero', 'Calle 50 #60-70', '147258369', 'sara@example.com', 1),
('Tomas', 'Vega', 'Avenida 9 de Julio 1000', '258369147', 'tomas@example.com', 1),
('Clara', 'Paredes', 'Calle 200 #300-400', '369147258', 'clara@example.com', 1),
('Miguel', 'Santos', 'Carrera 50 #60-70', '159357486', 'miguel@example.com', 1);

-- -----------------------------------------------------
-- Inserción de datos en Autores_Libros (20 registros)
-- -----------------------------------------------------
INSERT INTO Autores_Libros (id_autor, id_libro) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18),
(19, 19),
(20, 20);

-- -----------------------------------------------------
-- Inserción de datos en Ejemplares (20 registros)
-- -----------------------------------------------------
INSERT INTO Ejemplares (id_libro, id_sede, ubicacion, estado) VALUES
(1, 1, 'Estanteria A1', 'Disponible'),
(2, 1, 'Estanteria A2', 'Prestado'),
(3, 1, 'Estanteria A3', 'Reservado'),
(4, 1, 'Estanteria A4', 'Disponible'),
(5, 1, 'Estanteria A5', 'Disponible'),
(6, 1, 'Estanteria A6', 'Disponible'),
(7, 1, 'Estanteria A7', 'Disponible'),
(8, 1, 'Estanteria A8', 'Prestado'),
(9, 1, 'Estanteria A9', 'Disponible'),
(10, 1, 'Estanteria A10', 'Disponible'),
(11, 2, 'Estanteria B1', 'Disponible'),
(12, 2, 'Estanteria B2', 'Prestado'),
(13, 2, 'Estanteria B3', 'Disponible'),
(14, 2, 'Estanteria B4', 'Disponible'),
(15, 2, 'Estanteria B5', 'Disponible'),
(16, 2, 'Estanteria B6', 'Disponible'),
(17, 2, 'Estanteria B7', 'Disponible'),
(18, 2, 'Estanteria B8', 'Prestado'),
(19, 2, 'Estanteria B9', 'Disponible'),
(20, 2, 'Estanteria B10', 'Disponible');

-- -----------------------------------------------------
-- Inserción de datos en Prestamos (20 registros)
-- -----------------------------------------------------
INSERT INTO Prestamos (fecha_prestamo, fecha_devolucion_estimada, fecha_devolucion_real, estado_prestamo, id_usuario, id_libro, id_sede) VALUES
('2024-01-10', '2024-01-24', '2024-01-23', 'Devuelto', 1, 2, 1),
('2024-02-01', '2024-02-15', NULL, 'Pendiente', 2, 3, 1),
('2024-02-10', '2024-02-24', '2024-02-25', 'Devuelto', 3, 4, 1),
('2024-03-01', '2024-03-15', NULL, 'Pendiente', 4, 5, 1),
('2024-03-10', '2024-03-24', NULL, 'Pendiente', 5, 6, 1),
('2024-04-01', '2024-04-15', '2024-04-14', 'Devuelto', 6, 7, 1),
('2024-04-10', '2024-04-24', NULL, 'Pendiente', 7, 8, 1),
('2024-05-01', '2024-05-15', NULL, 'Pendiente', 8, 9, 1),
('2024-05-10', '2024-05-24', NULL, 'Pendiente', 9, 10, 1),
('2024-06-01', '2024-06-15', NULL, 'Pendiente', 10, 1, 1),
('2024-06-05', '2024-06-19', '2024-06-18', 'Devuelto', 11, 11, 1),
('2024-06-10', '2024-06-24', NULL, 'Pendiente', 12, 12, 1),
('2024-06-15', '2024-06-29', NULL, 'Pendiente', 13, 13, 1),
('2024-07-01', '2024-07-15', '2024-07-14', 'Devuelto', 14, 14, 1),
('2024-07-05', '2024-07-19', NULL, 'Pendiente', 15, 15, 1),
('2024-07-10', '2024-07-24', NULL, 'Pendiente', 16, 16, 1),
('2024-07-15', '2024-07-29', '2024-07-28', 'Devuelto', 17, 17, 1),
('2024-08-01', '2024-08-15', NULL, 'Pendiente', 18, 18, 1),
('2024-08-05', '2024-08-19', NULL, 'Pendiente', 19, 19, 1),
('2024-08-10', '2024-08-24', NULL, 'Pendiente', 20, 20, 1);

-- -----------------------------------------------------
-- Inserción de datos en Devoluciones (10 registros)
-- -----------------------------------------------------
INSERT INTO Devoluciones (id_prestamo, fecha_devolucion, multa_aplicada, observaciones) VALUES
(1, '2024-01-23', 0.00, 'Devolucion a tiempo'),
(3, '2024-02-25', 2.50, 'Devolucion con retraso'),
(6, '2024-04-14', 0.00, 'Devolucion a tiempo'),
(11, '2024-06-18', 0.00, 'Devolucion a tiempo'),
(14, '2024-07-14', 0.00, 'Devolucion a tiempo'),
(17, '2024-07-28', 0.00, 'Devolucion a tiempo'),
(2, '2024-02-20', 5.00, 'Devolucion muy tarde'),
(12, '2024-06-25', 2.00, 'Devolucion con retraso'),
(13, '2024-07-01', 0.00, 'Devolucion anticipada'),
(15, '2024-07-20', 1.00, 'Devolucion con retraso');

-- -----------------------------------------------------
-- Inserción de datos en Multas (10 registros)
-- -----------------------------------------------------
INSERT INTO Multas (id_usuario, monto, fecha_aplicacion, pagada) VALUES
(2, 2.50, '2024-02-25', false),
(7, 5.00, '2024-04-25', true),
(12, 2.00, '2024-06-25', false),
(15, 1.00, '2024-07-20', true),
(2, 10.00, '2024-03-01', false),
(3, 3.00, '2024-02-26', true),
(8, 2.50, '2024-05-16', false),
(9, 1.50, '2024-05-25', false),
(10, 5.00, '2024-06-16', false),
(19, 3.00, '2024-08-20', false);

-- -----------------------------------------------------
-- Inserción de datos en Reservas (10 registros)
-- -----------------------------------------------------
INSERT INTO Reservas (id_usuario, id_libro, fecha_reserva, estado) VALUES
(1, 3, '2024-02-01', 'Activa'),
(2, 5, '2024-03-01', 'Activa'),
(3, 7, '2024-04-01', 'Cancelada'),
(4, 9, '2024-05-01', 'Activa'),
(5, 11, '2024-06-01', 'Activa'),
(6, 13, '2024-07-01', 'Activa'),
(7, 15, '2024-07-05', 'Activa'),
(8, 17, '2024-07-10', 'Activa'),
(9, 19, '2024-08-01', 'Activa'),
(10, 20, '2024-08-05', 'Activa');

-- -----------------------------------------------------
-- Inserción de datos en HistorialPrestamos (10 registros)
-- -----------------------------------------------------
INSERT INTO HistorialPrestamos (id_usuario, id_libro, id_prestamo, dias_retraso, multa_generada, fecha_inicio, fecha_fin) VALUES
(1, 2, 1, 0, 0.00, '2024-01-10', '2024-01-23'),
(2, 3, 2, 5, 2.50, '2024-02-01', '2024-02-25'),
(3, 4, 3, 1, 0.00, '2024-02-10', '2024-02-25'),
(4, 5, 4, 0, 0.00, '2024-03-01', NULL),
(5, 6, 5, 0, 0.00, '2024-03-10', NULL),
(6, 7, 6, 0, 0.00, '2024-04-01', '2024-04-14'),
(7, 8, 7, 0, 0.00, '2024-04-10', NULL),
(8, 9, 8, 0, 0.00, '2024-05-01', NULL),
(9, 10, 9, 0, 0.00, '2024-05-10', NULL),
(10, 1, 10, 0, 0.00, '2024-06-01', NULL);

-- -----------------------------------------------------
-- Creación de vistas
-- -----------------------------------------------------

-- Vista 1: Libros disponibles
CREATE VIEW v_libros_disponibles AS
SELECT l.titulo, e.nombre_editorial, g.nombre_genero, l.disponibilidad
FROM Libros l
JOIN Editoriales e ON l.id_editorial = e.id_editorial
JOIN Generos g ON l.id_genero = g.id_genero
WHERE l.disponibilidad = true;

-- Vista 2: Préstamos activos
CREATE VIEW v_prestamos_activos AS
SELECT u.nombre, u.apellido, l.titulo, p.fecha_prestamo, p.fecha_devolucion_estimada
FROM Prestamos p
JOIN Usuarios u ON p.id_usuario = u.id_usuario
JOIN Libros l ON p.id_libro = l.id_libro
WHERE p.fecha_devolucion_real IS NULL;

-- Vista 3: Historial de préstamos por usuario
CREATE VIEW v_historial_prestamos_usuario AS
SELECT u.nombre, u.apellido, l.titulo, p.fecha_prestamo, p.fecha_devolucion_real, p.estado_prestamo
FROM Prestamos p
JOIN Usuarios u ON p.id_usuario = u.id_usuario
JOIN Libros l ON p.id_libro = l.id_libro;

-- Vista 4: Autores con libros publicados
CREATE VIEW v_autores_libros AS
SELECT a.nombre_autor, a.apellido_autor, l.titulo
FROM Autores_Libros al
JOIN Autores a ON al.id_autor = a.id_autor
JOIN Libros l ON al.id_libro = l.id_libro;

-- Vista 5: Multas pendientes de pago
CREATE VIEW v_multas_pendientes AS
SELECT u.nombre, u.apellido, m.monto, m.fecha_aplicacion
FROM Multas m
JOIN Usuarios u ON m.id_usuario = u.id_usuario
WHERE m.pagada = false;

-- -----------------------------------------------------
-- Creación de funciones (corregidas)
-- -----------------------------------------------------

DELIMITER $$
CREATE FUNCTION fn_calcular_dias_retraso(fecha_real DATE, fecha_estimada DATE)
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE dias INT DEFAULT 0;
    IF fecha_real IS NOT NULL AND fecha_real > fecha_estimada THEN
        SET dias = DATEDIFF(fecha_real, fecha_estimada);
    END IF;
    RETURN dias;
END$$

CREATE FUNCTION fn_total_prestamos_usuario(p_id_usuario INT)
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE total INT DEFAULT 0;
    SELECT COUNT(*) INTO total FROM Prestamos WHERE id_usuario = p_id_usuario;
    RETURN total;
END$$

CREATE FUNCTION fn_libros_por_genero(p_genero VARCHAR(50))
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE total INT DEFAULT 0;
    SELECT COUNT(*) INTO total FROM Libros l JOIN Generos g ON l.id_genero = g.id_genero WHERE g.nombre_genero = p_genero;
    RETURN total;
END$$
DELIMITER ;

-- -----------------------------------------------------
-- Creación de stored procedures
-- -----------------------------------------------------

DELIMITER $$
CREATE PROCEDURE sp_registrar_prestamo(
    IN p_id_usuario INT,
    IN p_id_libro INT,
    IN p_fecha_prestamo DATE,
    IN p_fecha_devolucion_estimada DATE,
    IN p_id_sede INT
)
BEGIN
    UPDATE Libros SET disponibilidad = false WHERE id_libro = p_id_libro;
    INSERT INTO Prestamos (fecha_prestamo, fecha_devolucion_estimada, estado_prestamo, id_usuario, id_libro, id_sede)
    VALUES (p_fecha_prestamo, p_fecha_devolucion_estimada, 'Pendiente', p_id_usuario, p_id_libro, p_id_sede);
    SELECT 'Prestamo registrado exitosamente' AS mensaje;
END$$

CREATE PROCEDURE sp_devolver_libro(
    IN p_id_prestamo INT,
    IN p_fecha_devolucion DATE
)
BEGIN
    UPDATE Prestamos SET fecha_devolucion_real = p_fecha_devolucion, estado_prestamo = 'Devuelto' WHERE id_prestamo = p_id_prestamo;
    UPDATE Libros SET disponibilidad = true WHERE id_libro = (SELECT id_libro FROM Prestamos WHERE id_prestamo = p_id_prestamo);
    SELECT 'Libro devuelto exitosamente' AS mensaje;
END$$

CREATE PROCEDURE sp_buscar_libros_por_genero(
    IN p_genero VARCHAR(50)
)
BEGIN
    SELECT l.titulo, e.nombre_editorial, g.nombre_genero
    FROM Libros l
    JOIN Editoriales e ON l.id_editorial = e.id_editorial
    JOIN Generos g ON l.id_genero = g.id_genero
    WHERE g.nombre_genero = p_genero;
END$$
DELIMITER ;

-- -----------------------------------------------------
-- Creación de triggers (corregidos)
-- Solo se mantienen los que no entran en conflicto
-- -----------------------------------------------------

DELIMITER $$
CREATE TRIGGER tr_actualizar_disponibilidad_libro
AFTER INSERT ON Prestamos
FOR EACH ROW
BEGIN
    UPDATE Libros SET disponibilidad = false WHERE id_libro = NEW.id_libro;
END$$

CREATE TRIGGER tr_actualizar_disponibilidad_devolucion
AFTER UPDATE ON Prestamos
FOR EACH ROW
BEGIN
    IF NEW.fecha_devolucion_real IS NOT NULL AND OLD.fecha_devolucion_real IS NULL THEN
        UPDATE Libros SET disponibilidad = true WHERE id_libro = NEW.id_libro;
    END IF;
END$$

CREATE TRIGGER tr_eliminar_libro_prestamo
BEFORE DELETE ON Libros
FOR EACH ROW
BEGIN
    DELETE FROM Prestamos WHERE id_libro = OLD.id_libro;
END$$
DELIMITER ;