package com.condominios.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class PaseDeVisitaResponse {

    private Long id;
    private Long residenteId;
    private String nombreVisitante;
    private String codigoQr;
    private LocalDate fechaValidez;
    private String estado;
    private LocalDateTime fechaCreacion;

    public PaseDeVisitaResponse() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getResidenteId() { return residenteId; }
    public void setResidenteId(Long residenteId) { this.residenteId = residenteId; }

    public String getNombreVisitante() { return nombreVisitante; }
    public void setNombreVisitante(String nombreVisitante) { this.nombreVisitante = nombreVisitante; }

    public String getCodigoQr() { return codigoQr; }
    public void setCodigoQr(String codigoQr) { this.codigoQr = codigoQr; }

    public LocalDate getFechaValidez() { return fechaValidez; }
    public void setFechaValidez(LocalDate fechaValidez) { this.fechaValidez = fechaValidez; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public LocalDateTime getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(LocalDateTime fechaCreacion) { this.fechaCreacion = fechaCreacion; }
}
