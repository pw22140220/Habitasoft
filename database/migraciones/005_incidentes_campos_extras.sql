-- Migración 005: Agregar campos adicionales a la tabla Incidentes
ALTER TABLE Incidentes
    ADD COLUMN tipo VARCHAR(50) NOT NULL DEFAULT 'General',
    ADD COLUMN ubicacion VARCHAR(150) NOT NULL DEFAULT '',
    ADD COLUMN prioridad ENUM('ALTA', 'MEDIA', 'BAJA') NOT NULL DEFAULT 'MEDIA',
    ADD COLUMN estado ENUM('nuevo', 'en_progreso', 'resuelto') NOT NULL DEFAULT 'nuevo',
    ADD COLUMN fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
