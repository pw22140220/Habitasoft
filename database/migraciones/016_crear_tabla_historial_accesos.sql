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

CREATE INDEX idx_historial_condominio ON HistorialAccesos(condominio_id);
CREATE INDEX idx_historial_guardia ON HistorialAccesos(guardia_id);
CREATE INDEX idx_historial_fecha ON HistorialAccesos(fecha_acceso);
