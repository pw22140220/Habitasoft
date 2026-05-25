package com.condominios.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "Reservaciones")
public class Reservacion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "amenidad_id", nullable = false)
    private Long amenidadId;

    @Column(name = "residente_id", nullable = false)
    private Long residenteId;

    @Column(name = "fecha_hora_inicio", nullable = false)
    private LocalDateTime fechaHoraInicio;

    @Column(name = "fecha_hora_fin", nullable = false)
    private LocalDateTime fechaHoraFin;

    @Enumerated(EnumType.STRING)
    @Column(name = "estado")
    private EstadoReservacion estado = EstadoReservacion.confirmada;

    public enum EstadoReservacion {
        confirmada, pendiente, cancelada
    }

    public Reservacion() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getAmenidadId() { return amenidadId; }
    public void setAmenidadId(Long amenidadId) { this.amenidadId = amenidadId; }

    public Long getResidenteId() { return residenteId; }
    public void setResidenteId(Long residenteId) { this.residenteId = residenteId; }

    public LocalDateTime getFechaHoraInicio() { return fechaHoraInicio; }
    public void setFechaHoraInicio(LocalDateTime fechaHoraInicio) { this.fechaHoraInicio = fechaHoraInicio; }

    public LocalDateTime getFechaHoraFin() { return fechaHoraFin; }
    public void setFechaHoraFin(LocalDateTime fechaHoraFin) { this.fechaHoraFin = fechaHoraFin; }

    public EstadoReservacion getEstado() { return estado; }
    public void setEstado(EstadoReservacion estado) { this.estado = estado; }
}
