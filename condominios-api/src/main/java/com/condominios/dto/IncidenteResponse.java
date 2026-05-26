package com.condominios.dto;

import com.condominios.model.Incidente.Estado;
import com.condominios.model.Incidente.Prioridad;
import java.time.LocalDateTime;

public class IncidenteResponse {

    private Long id;
    private Long reportadoPorId;
    private Long condominioId;
    private String nombreReportador;
    private String titulo;
    private String descripcion;
    private String tipo;
    private String ubicacion;
    private Prioridad prioridad;
    private Estado estado;
    private LocalDateTime fechaHoraIncidente;
    private LocalDateTime fechaActualizacion;

    public IncidenteResponse() {}

    public IncidenteResponse(Long id, Long reportadoPorId, Long condominioId, String nombreReportador, String titulo,
                             String descripcion, String tipo, String ubicacion, Prioridad prioridad,
                             Estado estado, LocalDateTime fechaHoraIncidente, LocalDateTime fechaActualizacion) {
        this.id = id;
        this.reportadoPorId = reportadoPorId;
        this.condominioId = condominioId;
        this.nombreReportador = nombreReportador;
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

    public String getNombreReportador() { return nombreReportador; }
    public void setNombreReportador(String nombreReportador) { this.nombreReportador = nombreReportador; }

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
