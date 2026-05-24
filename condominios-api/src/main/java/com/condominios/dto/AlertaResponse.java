package com.condominios.dto;

import com.condominios.model.Alerta.Prioridad;
import java.time.LocalDateTime;

public class AlertaResponse {

    private Long id;
    private String titulo;
    private String mensaje;
    private Prioridad prioridad;
    private Long condominioId;
    private Long creadoPorId;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaExpiracion;
    private Boolean activa;

    // Constructor por defecto
    public AlertaResponse() {}

    // Constructor con todos los campos
    public AlertaResponse(Long id, String titulo, String mensaje, Prioridad prioridad, 
                          Long condominioId, Long creadoPorId, LocalDateTime fechaCreacion, 
                          LocalDateTime fechaExpiracion, Boolean activa) {
        this.id = id;
        this.titulo = titulo;
        this.mensaje = mensaje;
        this.prioridad = prioridad;
        this.condominioId = condominioId;
        this.creadoPorId = creadoPorId;
        this.fechaCreacion = fechaCreacion;
        this.fechaExpiracion = fechaExpiracion;
        this.activa = activa;
    }

    // Getters y Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public Prioridad getPrioridad() {
        return prioridad;
    }

    public void setPrioridad(Prioridad prioridad) {
        this.prioridad = prioridad;
    }

    public Long getCondominioId() {
        return condominioId;
    }

    public void setCondominioId(Long condominioId) {
        this.condominioId = condominioId;
    }

    public Long getCreadoPorId() {
        return creadoPorId;
    }

    public void setCreadoPorId(Long creadoPorId) {
        this.creadoPorId = creadoPorId;
    }

    public LocalDateTime getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(LocalDateTime fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public LocalDateTime getFechaExpiracion() {
        return fechaExpiracion;
    }

    public void setFechaExpiracion(LocalDateTime fechaExpiracion) {
        this.fechaExpiracion = fechaExpiracion;
    }

    public Boolean getActiva() {
        return activa;
    }

    public void setActiva(Boolean activa) {
        this.activa = activa;
    }
}