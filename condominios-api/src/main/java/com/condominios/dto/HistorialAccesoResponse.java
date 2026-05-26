package com.condominios.dto;

import java.time.LocalDateTime;

public class HistorialAccesoResponse {

    private Long id;
    private Long paseVisitaId;
    private Long guardiaId;
    private Long residenteId;
    private String nombreVisitante;
    private String codigoQr;
    private LocalDateTime fechaAcceso;
    private Long condominioId;
    private String guardiaNombre;
    private String residenteNombre;
    private String unidadNumero;

    public HistorialAccesoResponse() {}

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

    public String getGuardiaNombre() { return guardiaNombre; }
    public void setGuardiaNombre(String guardiaNombre) { this.guardiaNombre = guardiaNombre; }

    public String getResidenteNombre() { return residenteNombre; }
    public void setResidenteNombre(String residenteNombre) { this.residenteNombre = residenteNombre; }

    public String getUnidadNumero() { return unidadNumero; }
    public void setUnidadNumero(String unidadNumero) { this.unidadNumero = unidadNumero; }
}
