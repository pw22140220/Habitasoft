package com.condominios.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "Incidentes")
public class Incidente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "reportado_por_id", nullable = false)
    private Long reportadoPorId;

    @Column(name = "condominio_id")
    private Long condominioId;

    @Column(name = "titulo", length = 150)
    private String titulo;

    @Column(name = "descripcion", columnDefinition = "TEXT")
    private String descripcion;

    @Column(name = "tipo", nullable = false, length = 50)
    private String tipo;

    @Column(name = "ubicacion", nullable = false, length = 150)
    private String ubicacion;

    @Enumerated(EnumType.STRING)
    @Column(name = "prioridad", nullable = false)
    private Prioridad prioridad;

    @Enumerated(EnumType.STRING)
    @Column(name = "estado", nullable = false)
    private Estado estado;

    @Column(name = "fecha_hora_incidente", insertable = false, updatable = false)
    private LocalDateTime fechaHoraIncidente;

    @Column(name = "fecha_actualizacion", insertable = false, updatable = false)
    private LocalDateTime fechaActualizacion;

    public enum Prioridad {
        ALTA, MEDIA, BAJA
    }

    public enum Estado {
        nuevo, en_progreso, resuelto
    }

    public Incidente() {}

    public Incidente(Long id, Long reportadoPorId, Long condominioId, String titulo, String descripcion,
                     String tipo, String ubicacion, Prioridad prioridad, Estado estado,
                     LocalDateTime fechaHoraIncidente, LocalDateTime fechaActualizacion) {
        this.id = id;
        this.reportadoPorId = reportadoPorId;
        this.condominioId = condominioId;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.tipo = tipo;
        this.ubicacion = ubicacion;
        this.prioridad = prioridad;
        this.estado = estado;
        this.fechaHoraIncidente = fechaHoraIncidente;
        this.fechaActualizacion = fechaActualizacion;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getReportadoPorId() { return reportadoPorId; }
    public void setReportadoPorId(Long reportadoPorId) { this.reportadoPorId = reportadoPorId; }

    public Long getCondominioId() { return condominioId; }
    public void setCondominioId(Long condominioId) { this.condominioId = condominioId; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public String getUbicacion() { return ubicacion; }
    public void setUbicacion(String ubicacion) { this.ubicacion = ubicacion; }

    public Prioridad getPrioridad() { return prioridad; }
    public void setPrioridad(Prioridad prioridad) { this.prioridad = prioridad; }

    public Estado getEstado() { return estado; }
    public void setEstado(Estado estado) { this.estado = estado; }

    public LocalDateTime getFechaHoraIncidente() { return fechaHoraIncidente; }
    public void setFechaHoraIncidente(LocalDateTime fechaHoraIncidente) { this.fechaHoraIncidente = fechaHoraIncidente; }

    public LocalDateTime getFechaActualizacion() { return fechaActualizacion; }
    public void setFechaActualizacion(LocalDateTime fechaActualizacion) { this.fechaActualizacion = fechaActualizacion; }
}
