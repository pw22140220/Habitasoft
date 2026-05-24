-- =========================================
-- MIGRACIÓN 002: AGREGAR fecha_creacion A CONDOMINIOS
-- =========================================
-- Ejecutar después de 001_inicial.sql

ALTER TABLE Condominios
ADD COLUMN fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
