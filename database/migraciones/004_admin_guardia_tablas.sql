-- =========================================
-- MIGRACIÓN 004: Tablas Admin_Condominio y Guardia_Condominio
-- =========================================

CREATE TABLE IF NOT EXISTS Admin_Condominio (
    admin_id BIGINT NOT NULL,
    condominio_id BIGINT NOT NULL,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (admin_id, condominio_id),
    FOREIGN KEY (admin_id) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (condominio_id) REFERENCES Condominios(id) ON DELETE CASCADE
);

CREATE INDEX idx_admin_condominio_admin ON Admin_Condominio(admin_id);
CREATE INDEX idx_admin_condominio_condominio ON Admin_Condominio(condominio_id);

CREATE TABLE IF NOT EXISTS Guardia_Condominio (
    guardia_id BIGINT NOT NULL,
    condominio_id BIGINT NOT NULL,
    PRIMARY KEY (guardia_id, condominio_id),
    FOREIGN KEY (guardia_id) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (condominio_id) REFERENCES Condominios(id) ON DELETE CASCADE
);

CREATE INDEX idx_guardia_condominio_guardia ON Guardia_Condominio(guardia_id);
CREATE INDEX idx_guardia_condominio_condominio ON Guardia_Condominio(condominio_id);

-- Asignar el admin existente al condominio 1 (ajusta el ID según tu BD)
-- INSERT INTO Admin_Condominio (admin_id, condominio_id) VALUES (1, 1);
-- INSERT INTO Admin_Condominio (admin_id, condominio_id) VALUES (1, 2);
