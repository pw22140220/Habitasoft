package com.condominios.dto;

import java.time.LocalDateTime;

public class ReservacionResponse {

    private Long id;
    private Long amenidadId;
    private String amenidadNombre;
    private Long residenteId;
    private String residenteNombre;
    private LocalDateTime fechaHoraInicio;
    private LocalDateTime fechaHoraFin;
    private String estado;

    public ReservacionResponse() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getAmenidadId() { return amenidadId; }
    public void setAmenidadId(Long amenidadId) { this.amenidadId = amenidadId; }

    public String getAmenidadNombre() { return amenidadNombre; }
    public void setAmenidadNombre(String amenidadNombre) { this.amenidadNombre = amenidadNombre; }

    public Long getResidenteId() { return residenteId; }
    public void setResidenteId(Long residenteId) { this.residenteId = residenteId; }

    public String getResidenteNombre() { return residenteNombre; }
    public void setResidenteNombre(String residenteNombre) { this.residenteNombre = residenteNombre; }

    public LocalDateTime getFechaHoraInicio() { return fechaHoraInicio; }
    public void setFechaHoraInicio(LocalDateTime fechaHoraInicio) { this.fechaHoraInicio = fechaHoraInicio; }

    public LocalDateTime getFechaHoraFin() { return fechaHoraFin; }
    public void setFechaHoraFin(LocalDateTime fechaHoraFin) { this.fechaHoraFin = fechaHoraFin; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}
