package com.condominios.dto;

import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;

public class ReservacionRequest {

    @NotNull
    private Long amenidadId;

    @NotNull
    private LocalDateTime fechaHoraInicio;

    @NotNull
    private LocalDateTime fechaHoraFin;

    public ReservacionRequest() {}

    public Long getAmenidadId() { return amenidadId; }
    public void setAmenidadId(Long amenidadId) { this.amenidadId = amenidadId; }

    public LocalDateTime getFechaHoraInicio() { return fechaHoraInicio; }
    public void setFechaHoraInicio(LocalDateTime fechaHoraInicio) { this.fechaHoraInicio = fechaHoraInicio; }

    public LocalDateTime getFechaHoraFin() { return fechaHoraFin; }
    public void setFechaHoraFin(LocalDateTime fechaHoraFin) { this.fechaHoraFin = fechaHoraFin; }
}
