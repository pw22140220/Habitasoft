-- Estructura Inicial de HabitaSoft
CREATE DATABASE IF NOT EXISTS habitasoft_db;
USE habitasoft_db;

-- Tabla de Usuarios (Admin, Residente, Guardia)
CREATE TABLE Usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    rol ENUM('administrador', 'residente', 'guardia') NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Condominios y Unidades
CREATE TABLE Condominios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    direccion TEXT
);

CREATE TABLE Unidades (
    id INT PRIMARY KEY AUTO_INCREMENT,
    condominio_id INT,
    numero_unidad VARCHAR(20) NOT NULL,
    FOREIGN KEY (condominio_id) REFERENCES Condominios(id)
);

CREATE TABLE Residente_Unidad (
    residente_id INT,
    unidad_id INT,
    PRIMARY KEY (residente_id, unidad_id),
    FOREIGN KEY (residente_id) REFERENCES Usuarios(id),
    FOREIGN KEY (unidad_id) REFERENCES Unidades(id)
);

-- Amenidades y Reservas
CREATE TABLE Amenidades (
    id INT PRIMARY KEY AUTO_INCREMENT,
    condominio_id INT,
    nombre VARCHAR(100) NOT NULL,
    capacidad_maxima INT,
    FOREIGN KEY (condominio_id) REFERENCES Condominios(id)
);

CREATE TABLE Reservaciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    amenidad_id INT,
    residente_id INT,
    fecha_hora_inicio DATETIME,
    fecha_hora_fin DATETIME,
    estado ENUM('confirmada', 'pendiente', 'cancelada') DEFAULT 'confirmada',
    FOREIGN KEY (amenidad_id) REFERENCES Amenidades(id),
    FOREIGN KEY (residente_id) REFERENCES Usuarios(id)
);

-- Seguridad (QRs e Incidentes)
CREATE TABLE PasesDeVisita (
    id INT PRIMARY KEY AUTO_INCREMENT,
    residente_id INT,
    nombre_visitante VARCHAR(100),
    codigo_qr VARCHAR(255) UNIQUE,
    fecha_validez DATE,
    estado ENUM('activo', 'usado', 'expirado') DEFAULT 'activo',
    FOREIGN KEY (residente_id) REFERENCES Usuarios(id)
);

CREATE TABLE Incidentes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    reportado_por_id INT,
    titulo VARCHAR(150),
    descripcion TEXT,
    fecha_hora_incidente TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reportado_por_id) REFERENCES Usuarios(id)
);

-- Notificaciones
CREATE TABLE Notificaciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    destinatario_id INT,
    tipo ENUM('alerta', 'recordatorio_pago'),
    mensaje TEXT,
    leido BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (destinatario_id) REFERENCES Usuarios(id)
);