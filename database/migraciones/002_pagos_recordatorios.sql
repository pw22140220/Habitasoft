-- =========================================
-- MIGRACIÓN: PAGOS - RECORDATORIOS
-- Agrega columnas periodo y fecha_vencimiento a la tabla Pagos
-- =========================================

ALTER TABLE Pagos
ADD COLUMN periodo VARCHAR(50) NULL COMMENT 'Ej: Mayo 2025' AFTER monto,
ADD COLUMN fecha_vencimiento DATE NULL AFTER periodo;
