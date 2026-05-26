ALTER TABLE Anuncios 
ADD COLUMN destinatario ENUM('residentes', 'guardias', 'ambos') DEFAULT 'ambos' AFTER destacado;

CREATE INDEX idx_anuncios_destinatario ON Anuncios(destinatario);
