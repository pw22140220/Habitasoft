package com.condominios.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "HistorialAccesos")
public class HistorialAcceso {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "pase_visita_id", nullable = false)
    private Long paseVisitaId;

    @Column(name = "guardia_id", nullable = false)
    private Long guardiaId;

    @Column(name = "residente_id", nullable = false)
    private Long residenteId;

    @Column(name = "nombre_visitante", nullable = false, length = 100)
    private String nombreVisitante;

    @Column(name = "codigo_qr", nullable = false, length = 255)
    private String codigoQr;

    @Column(name = "fecha_acceso", insertable = false, updatable = false)
    private LocalDateTime fechaAcceso;

    @Column(name = "condominio_id", nullable = false)
    private Long condominioId;

    public HistorialAcceso() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getPaseVisitaId() { return paseVisitaId; }
    public void setPaseVisitaId(Long paseVisitaId) { this.paseVisitaId = paseVisitaId; }

    public Long getGuardiaId() { return guardiaId; }
    public void setGuardiaId(Long guardiaId) { this.guardiaId = guardiaId; }

    public Long getResidenteId() { return residenteId; }
    public void setResidenteId(Long residenteId) { this.residenteId = residenteId; }

    public String getNombreVisitante() { return nombreVisitante; }
    public void setNombreVisitante(String nombreVisitante) { this.nombreVisitante = nombreVisitante; }

    public String getCodigoQr() { return codigoQr; }
    public void setCodigoQr(String codigoQr) { this.codigoQr = codigoQr; }

    public LocalDateTime getFechaAcceso() { return fechaAcceso; }
    public void setFechaAcceso(LocalDateTime fechaAcceso) { this.fechaAcceso = fechaAcceso; }

    public Long getCondominioId() { return condominioId; }
    public void setCondominioId(Long condominioId) { this.condominioId = condominioId; }
}
