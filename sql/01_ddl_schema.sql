-- Creación y uso de la base de datos
CREATE DATABASE IF NOT EXISTS biblioia;
USE biblioia;

-- ==========================================
-- 1. TABLAS DE CATÁLOGO (Sin dependencias)
-- ==========================================

CREATE TABLE AUTOR (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50)
);

CREATE TABLE GENERO (
    id_genero INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
);

CREATE TABLE LIBRO (
    isbn VARCHAR(20) PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    anio_publicacion INT,
    stock_total INT NOT NULL CHECK (stock_total >= 0),
    stock_disponible INT NOT NULL,
    CONSTRAINT chk_stock CHECK (stock_disponible <= stock_total AND stock_disponible >= 0)
);

-- Índice en ISBN para búsquedas rápidas 
CREATE INDEX idx_libro_isbn ON LIBRO(isbn);

-- ==========================================
-- 2. TABLAS INTERMEDIAS (Relaciones N:M)
-- ==========================================

CREATE TABLE LIBRO_AUTOR (
    isbn VARCHAR(20),
    id_autor INT,
    PRIMARY KEY (isbn, id_autor),
    FOREIGN KEY (isbn) REFERENCES LIBRO(isbn) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES AUTOR(id_autor) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE LIBRO_GENERO (
    isbn VARCHAR(20),
    id_genero INT,
    PRIMARY KEY (isbn, id_genero),
    FOREIGN KEY (isbn) REFERENCES LIBRO(isbn) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_genero) REFERENCES GENERO(id_genero) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ==========================================
-- 3. TABLAS OPERATIVAS Y FÍSICAS
-- ==========================================

CREATE TABLE EJEMPLAR (
    id_ejemplar INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL,
    nro_ejemplar INT NOT NULL,
    estado_fisico VARCHAR(20) DEFAULT 'ACTIVO',
    CONSTRAINT chk_estado_fisico CHECK (estado_fisico IN ('ACTIVO', 'REGULAR', 'MALO', 'BAJA')),
    FOREIGN KEY (isbn) REFERENCES LIBRO(isbn) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE SOCIO (
    id_socio INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(15) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    fecha_alta DATE NOT NULL,
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    CONSTRAINT chk_estado_socio CHECK (estado IN ('ACTIVO', 'SUSPENDIDO', 'BAJA'))
);

-- Índices en DNI y Email para búsquedas rápidas 
CREATE INDEX idx_socio_dni ON SOCIO(dni);
CREATE INDEX idx_socio_email ON SOCIO(email);

CREATE TABLE PRESTAMO (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_socio INT NOT NULL,
    id_ejemplar INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    fecha_devolucion DATE,
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    CONSTRAINT chk_estado_prestamo CHECK (estado IN ('ACTIVO', 'DEVUELTO', 'VENCIDO')),
    FOREIGN KEY (id_socio) REFERENCES SOCIO(id_socio) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_ejemplar) REFERENCES EJEMPLAR(id_ejemplar) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE SANCION (
    id_sancion INT AUTO_INCREMENT PRIMARY KEY,
    id_socio INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    motivo TEXT,
    FOREIGN KEY (id_socio) REFERENCES SOCIO(id_socio) ON DELETE CASCADE ON UPDATE CASCADE
);