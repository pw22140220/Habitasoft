package com.condominios.dto;

import com.condominios.model.Incidente.Prioridad;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class IncidenteRequest {

    @NotBlank
    private String titulo;

    @NotBlank
    private String descripcion;

    @NotBlank
    private String tipo;

    @NotBlank
    private String ubicacion;

    @NotNull
    private Prioridad prioridad;

    private Long condominioId;

    public IncidenteRequest() {}

    public IncidenteRequest(String titulo, String descripcion, String tipo, String ubicacion, Prioridad prioridad, Long condominioId) {
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.tipo = tipo;
        this.ubicacion = ubicacion;
        this.prioridad = prioridad;
        this.condominioId = condominioId;
    }

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

    public Long getCondominioId() { return condominioId; }
    public void setCondominioId(Long condominioId) { this.condominioId = condominioId; }
}
