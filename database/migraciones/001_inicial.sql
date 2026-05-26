-- =========================================
-- CREACIÓN DE BASE DE DATOS
-- =========================================
CREATE DATABASE IF NOT EXISTS habitasoft_db;
USE habitasoft_db;

-- =========================================
-- TABLA USUARIOS
-- =========================================
CREATE TABLE Usuarios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    nombre VARCHAR(100) NOT NULL,

    email VARCHAR(100) UNIQUE NOT NULL,

    password_hash VARCHAR(255) NOT NULL,

    telefono VARCHAR(20),

    rol ENUM(
        'administrador',
        'residente',
        'guardia'
    ) NOT NULL,

    fecha_creacion TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
);

-- =========================================
-- TABLA CONDOMINIOS
-- =========================================
CREATE TABLE Condominios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    nombre VARCHAR(150) NOT NULL,

    direccion TEXT
);

-- =========================================
-- TABLA UNIDADES
-- =========================================
CREATE TABLE Unidades (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    condominio_id BIGINT NOT NULL,

    numero_unidad VARCHAR(20) NOT NULL,

    FOREIGN KEY (condominio_id)
    REFERENCES Condominios(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- =========================================
-- RELACIÓN RESIDENTE - UNIDAD
-- =========================================
CREATE TABLE Residente_Unidad (

    residente_id BIGINT ,

    unidad_id BIGINT ,

    PRIMARY KEY (residente_id, unidad_id),

    FOREIGN KEY (residente_id)
    REFERENCES Usuarios(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    FOREIGN KEY (unidad_id)
    REFERENCES Unidades(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- =========================================
-- TABLA AMENIDADES
-- =========================================
CREATE TABLE Amenidades (
    id BIGINT  PRIMARY KEY AUTO_INCREMENT,

    condominio_id BIGINT  NOT NULL,

    nombre VARCHAR(100) NOT NULL,

    capacidad_maxima BIGINT ,

    FOREIGN KEY (condominio_id)
    REFERENCES Condominios(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- =========================================
-- TABLA RESERVACIONES
-- =========================================
CREATE TABLE Reservaciones (
    id BIGINT  PRIMARY KEY AUTO_INCREMENT,

    amenidad_id BIGINT  NOT NULL,

    residente_id BIGINT  NOT NULL,

    fecha_hora_inicio DATETIME NOT NULL,

    fecha_hora_fin DATETIME NOT NULL,

    estado ENUM(
        'confirmada',
        'pendiente',
        'cancelada'
    ) DEFAULT 'confirmada',

    FOREIGN KEY (amenidad_id)
    REFERENCES Amenidades(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    FOREIGN KEY (residente_id)
    REFERENCES Usuarios(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- =========================================
-- TABLA PASES DE VISITA
-- =========================================
CREATE TABLE PasesDeVisita (
    id BIGINT  PRIMARY KEY AUTO_INCREMENT,

    residente_id BIGINT  NOT NULL,

    nombre_visitante VARCHAR(100),

    codigo_qr VARCHAR(255) UNIQUE,

    fecha_validez DATE,

    estado ENUM(
        'activo',
        'usado',
        'expirado'
    ) DEFAULT 'activo',

    FOREIGN KEY (residente_id)
    REFERENCES Usuarios(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- =========================================
-- TABLA INCIDENTES
-- =========================================
CREATE TABLE Incidentes (
    id BIGINT  PRIMARY KEY AUTO_INCREMENT,

    reportado_por_id BIGINT  NOT NULL,

    titulo VARCHAR(150) NOT NULL,
    prioridad ENUM('BAJA', 'MEDIA', 'ALTA') DEFAULT 'MEDIA',

    descripcion TEXT,

    fecha_hora_incidente TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (reportado_por_id)
    REFERENCES Usuarios(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- =========================================
-- TABLA NOTIFICACIONES
-- =========================================
CREATE TABLE Notificaciones (
    id BIGINT  PRIMARY KEY AUTO_INCREMENT,

    destinatario_id BIGINT  NOT NULL,

    tipo ENUM(
        'alerta',
        'recordatorio_pago'
    ),

    mensaje TEXT,

    leido BOOLEAN DEFAULT FALSE,

    fecha_envio TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (destinatario_id)
    REFERENCES Usuarios(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- =========================================
-- TABLA PAGOS
-- =========================================
CREATE TABLE Pagos (
    id BIGINT  PRIMARY KEY AUTO_INCREMENT,

    residente_id BIGINT  NOT NULL,

    monto DECIMAL(10,2) NOT NULL,

    fecha_pago TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP,

    metodo_pago ENUM(
        'transferencia',
        'tarjeta',
        'efectivo'
    ),

    estado ENUM(
        'pendiente',
        'pagado',
        'vencido'
    ) DEFAULT 'pendiente',

    FOREIGN KEY (residente_id)
    REFERENCES Usuarios(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
-- =========================================
-- TABLA ALERTAS (comunicados masivos del admin)
-- =========================================
CREATE TABLE IF NOT EXISTS Alertas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(100) NOT NULL,
    mensaje TEXT NOT NULL,
    prioridad ENUM('ALTA', 'MEDIA', 'BAJA') NOT NULL,
    condominio_id BIGINT NULL COMMENT 'NULL = todos los condominios',
    creado_por_id BIGINT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_expiracion TIMESTAMP NULL,
    activa BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (creado_por_id) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (condominio_id) REFERENCES Condominios(id) ON DELETE CASCADE
);
-- =========================================
-- TABLA Admin Condominio (admin puede tener muchos condominios)
-- =========================================
CREATE TABLE IF NOT EXISTS Admin_Condominio (
    admin_id BIGINT NOT NULL,
    condominio_id BIGINT NOT NULL,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (admin_id, condominio_id),
    FOREIGN KEY (admin_id) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (condominio_id) REFERENCES Condominios(id) ON DELETE CASCADE
);
-- =========================================
-- TABLA Guardia Condominio
-- =========================================
CREATE TABLE IF NOT EXISTS Guardia_Condominio (
    guardia_id BIGINT NOT NULL,
    condominio_id BIGINT NOT NULL,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (guardia_id, condominio_id),
    FOREIGN KEY (guardia_id) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (condominio_id) REFERENCES Condominios(id) ON DELETE CASCADE
);
-- =========================================
-- TABLA ANUNCIOS (comunicados comunitarios)
-- =========================================
CREATE TABLE IF NOT EXISTS Anuncios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    contenido TEXT NOT NULL,
    condominio_id BIGINT NOT NULL,
    creado_por_id BIGINT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_expiracion DATE NULL,
    activo BOOLEAN DEFAULT TRUE,
    destacado BOOLEAN DEFAULT FALSE,
    destinatario ENUM('residentes', 'guardias', 'ambos') DEFAULT 'ambos',
    imagen_url VARCHAR(500) NULL,
    
    FOREIGN KEY (condominio_id) REFERENCES Condominios(id) ON DELETE CASCADE,
    FOREIGN KEY (creado_por_id) REFERENCES Usuarios(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS HistorialAccesos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    pase_visita_id BIGINT NOT NULL,
    guardia_id BIGINT NOT NULL,
    residente_id BIGINT NOT NULL,
    nombre_visitante VARCHAR(100) NOT NULL,
    codigo_qr VARCHAR(255) NOT NULL,
    fecha_acceso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    condominio_id BIGINT NOT NULL,
    
    FOREIGN KEY (pase_visita_id) REFERENCES PasesDeVisita(id) ON DELETE CASCADE,
    FOREIGN KEY (guardia_id) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (residente_id) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (condominio_id) REFERENCES Condominios(id) ON DELETE CASCADE
);

-- =========================================
-- CHECK CONSTRAINTS
-- =========================================
ALTER TABLE Amenidades
ADD CONSTRAINT chk_capacidad
CHECK (capacidad_maxima > 0);

-- =========================================
-- ÍNDICES
-- =========================================

-- Usuarios
CREATE INDEX idx_usuario_rol
ON Usuarios(rol);

-- Unidades
CREATE INDEX idx_unidad_condominio
ON Unidades(condominio_id);

CREATE INDEX idx_unidad_condominio_numero
ON Unidades(condominio_id, numero_unidad);

-- Amenidades
CREATE INDEX idx_amenidad_condominio
ON Amenidades(condominio_id);

-- Reservaciones
CREATE INDEX idx_reservacion_amenidad
ON Reservaciones(amenidad_id);

CREATE INDEX idx_reservacion_residente
ON Reservaciones(residente_id);

CREATE INDEX idx_reservacion_fechas
ON Reservaciones(
    fecha_hora_inicio,
    fecha_hora_fin
);

CREATE INDEX idx_reservacion_amenidad_fecha
ON Reservaciones(
    amenidad_id,
    fecha_hora_inicio
);

-- Pases QR
CREATE INDEX idx_qr_codigo
ON PasesDeVisita(codigo_qr);

CREATE INDEX idx_qr_estado
ON PasesDeVisita(estado);

-- Incidentes
CREATE INDEX idx_incidente_usuario
ON Incidentes(reportado_por_id);

CREATE INDEX idx_incidente_fecha
ON Incidentes(fecha_hora_incidente);

-- Notificaciones
CREATE INDEX idx_notificacion_destinatario
ON Notificaciones(destinatario_id);

CREATE INDEX idx_notificacion_leido
ON Notificaciones(leido);

CREATE INDEX idx_notificacion_usuario_leido
ON Notificaciones(
    destinatario_id,
    leido
);

-- Pagos
CREATE INDEX idx_pago_residente
ON Pagos(residente_id);

CREATE INDEX idx_pago_estado
ON Pagos(estado);
-- Alertas
CREATE INDEX idx_alertas_condominio ON Alertas(condominio_id);
CREATE INDEX idx_alertas_activa ON Alertas(activa);
CREATE INDEX idx_alertas_fecha_expiracion ON Alertas(fecha_expiracion);
-- Amind_Condominio
CREATE INDEX idx_admin_condominio_admin ON Admin_Condominio(admin_id);
CREATE INDEX idx_admin_condominio_condominio ON Admin_Condominio(condominio_id);
-- guardia_condominio
CREATE INDEX idx_guardia_condominio_guardia ON Guardia_Condominio(guardia_id);
CREATE INDEX idx_guardia_condominio_condominio ON Guardia_Condominio(condominio_id);
-- Anuncios
CREATE INDEX idx_anuncios_condominio ON Anuncios(condominio_id);
CREATE INDEX idx_anuncios_activo ON Anuncios(activo);
CREATE INDEX idx_anuncios_destacado ON Anuncios(destacado);
CREATE INDEX idx_anuncios_fecha_expiracion ON Anuncios(fecha_expiracion);

-- HistorialAccesos
CREATE INDEX idx_historial_condominio ON HistorialAccesos(condominio_id);
CREATE INDEX idx_historial_guardia ON HistorialAccesos(guardia_id);
CREATE INDEX idx_historial_fecha ON HistorialAccesos(fecha_acceso);
-- Índice para filtrar por destinatario Anuncios 
CREATE INDEX idx_anuncios_destinatario ON Anuncios(destinatario);

-- =========================================
-- VISTAS (VIEWS)
-- =========================================

-- Vista residentes y unidades
CREATE VIEW Vista_Residentes_Unidades AS
SELECT
    u.id AS id_residente,
    u.nombre AS residente,
    u.email,
    un.numero_unidad,
    c.nombre AS condominio
FROM Usuarios u
INNER JOIN Residente_Unidad ru
    ON u.id = ru.residente_id
INNER JOIN Unidades un
    ON ru.unidad_id = un.id
INNER JOIN Condominios c
    ON un.condominio_id = c.id
WHERE u.rol = 'residente';

-- Vista reservaciones
CREATE VIEW Vista_Reservaciones AS
SELECT
    r.id,
    a.nombre AS amenidad,
    u.nombre AS residente,
    r.fecha_hora_inicio,
    r.fecha_hora_fin,
    r.estado
FROM Reservaciones r
INNER JOIN Amenidades a
    ON r.amenidad_id = a.id
INNER JOIN Usuarios u
    ON r.residente_id = u.id;

-- Vista incidentes
CREATE VIEW Vista_Incidentes AS
SELECT
    i.id,
    u.nombre AS reportado_por,
    i.titulo,
    i.descripcion,
    i.fecha_hora_incidente
FROM Incidentes i
INNER JOIN Usuarios u
    ON i.reportado_por_id = u.id;

-- Vista pagos
CREATE VIEW Vista_Pagos AS
SELECT
    p.id,
    u.nombre AS residente,
    p.monto,
    p.metodo_pago,
    p.estado,
    p.fecha_pago
FROM Pagos p
INNER JOIN Usuarios u
    ON p.residente_id = u.id;

-- =========================================
-- PROCEDIMIENTO ALMACENADO
-- =========================================

DELIMITER //

CREATE PROCEDURE CrearReservacion(
    IN p_amenidad_id BIGINT,
    IN p_residente_id BIGINT,
    IN p_inicio DATETIME,
    IN p_fin DATETIME
)
BEGIN

    DECLARE conflicto BIGINT;

    -- Validar fechas
    IF p_inicio >= p_fin THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'La fecha de inicio debe ser menor a la fecha final';

    ELSE

        -- Validar conflictos
        SELECT COUNT(*)
        INTO conflicto
        FROM Reservaciones
        WHERE amenidad_id = p_amenidad_id
        AND estado = 'confirmada'
        AND (
            p_inicio < fecha_hora_fin
            AND
            p_fin > fecha_hora_inicio
        );

        -- Si hay conflicto
        IF conflicto > 0 THEN

            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'La amenidad ya esta reservada en ese horario';

        ELSE

            -- Crear reservación
            INSERT INTO Reservaciones(
                amenidad_id,
                residente_id,
                fecha_hora_inicio,
                fecha_hora_fin,
                estado
            )
            VALUES(
                p_amenidad_id,
                p_residente_id,
                p_inicio,
                p_fin,
                'confirmada'
            );

        END IF;

    END IF;

END //

DELIMITER ;

-- =========================================
-- TRIGGER NOTIFICACIÓN RESERVA
-- =========================================

DELIMITER //

CREATE TRIGGER tr_notificacion_reserva
AFTER INSERT ON Reservaciones
FOR EACH ROW
BEGIN

    DECLARE nombreAmenidad VARCHAR(100);

    SELECT nombre
    INTO nombreAmenidad
    FROM Amenidades
    WHERE id = NEW.amenidad_id;

    INSERT INTO Notificaciones(
        destinatario_id,
        tipo,
        mensaje
    )
    VALUES(
        NEW.residente_id,
        'alerta',
        CONCAT(
            'Tu reservacion para ',
            nombreAmenidad,
            ' fue confirmada.'
        )
    );

END //

DELIMITER ;

-- =========================================
-- TRANSACCIÓN DE EJEMPLO
-- =========================================

START TRANSACTION;

INSERT INTO Usuarios(
    nombre,
    email,
    password_hash,
    telefono,
    rol
)
VALUES(
    'Juan Pérez',
    'juan@example.com',
    '123456HASH',
    '7221234567',
    'residente'
);

COMMIT;

-- Si ocurre error:
-- ROLLBACK;

-- =========================================
-- DATOS DE PRUEBA
-- =========================================

-- Condominio
INSERT INTO Condominios(
    nombre,
    direccion
)
VALUES(
    'Residencial Las Flores',
    'Toluca, Estado de México'
);

-- Unidad
INSERT INTO Unidades(
    condominio_id,
    numero_unidad
)
VALUES(
    1,
    'A-101'
);

-- Amenidad
INSERT INTO Amenidades(
    condominio_id,
    nombre,
    capacidad_maxima
)
VALUES(
    1,
    'Alberca',
    30
);

-- Usuario residente
INSERT INTO Usuarios(
    nombre,
    email,
    password_hash,
    telefono,
    rol
)
VALUES(
    'Carlos López',
    'carlos@example.com',
    'HASH456',
    '7220001111',
    'residente'
);

-- Relación residente-unidad
INSERT INTO Residente_Unidad(
    residente_id,
    unidad_id
)
VALUES(
    2,
    1
);

-- Usuario administrador
INSERT INTO Usuarios(
    nombre,
    email,
    password_hash,
    telefono,
    rol
)
VALUES(
    'Administrador General',
    'admin@habitasoft.com',
    'HASH_ADMIN',
    '7220000000',
    'administrador'
);

-- Pago de prueba
INSERT INTO Pagos(
    residente_id,
    monto,
    metodo_pago,
    estado
)
VALUES(
    2,
    1500.00,
    'transferencia',
    'pagado'
);

-- =========================================
-- EJEMPLO DE USO DEL PROCEDIMIENTO
-- =========================================

CALL CrearReservacion(
    1,
    2,
    '2026-05-20 18:00:00',
    '2026-05-20 20:00:00'
);