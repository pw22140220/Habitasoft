package com.condominios.dto;

import com.condominios.model.Alerta.Prioridad;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;

public class AlertaRequest {

    @NotBlank
    private String titulo;

    @NotBlank
    private String mensaje;

    @NotNull
    private Prioridad prioridad;

    @NotNull
    private Long condominioId;

    private LocalDateTime fechaExpiracion;

    // Constructor por defecto
    public AlertaRequest() {}

    // Constructor con todos los campos
    public AlertaRequest(String titulo, String mensaje, Prioridad prioridad, Long condominioId, LocalDateTime fechaExpiracion) {
        this.titulo = titulo;
        this.mensaje = mensaje;
        this.prioridad = prioridad;
        this.condominioId = condominioId;
        this.fechaExpiracion = fechaExpiracion;
    }

    // Getters y Setters
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

    public LocalDateTime getFechaExpiracion() {
        return fechaExpiracion;
    }

    public void setFechaExpiracion(LocalDateTime fechaExpiracion) {
        this.fechaExpiracion = fechaExpiracion;
    }
}