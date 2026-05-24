package com.condominios.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class AmenidadRequest {

    @NotBlank
    private String nombre;

    @NotNull
    private Long condominioId;

    private Long capacidadMaxima;

    public AmenidadRequest() {}

    public AmenidadRequest(String nombre, Long condominioId, Long capacidadMaxima) {
        this.nombre = nombre;
        this.condominioId = condominioId;
        this.capacidadMaxima = capacidadMaxima;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Long getCondominioId() {
        return condominioId;
    }

    public void setCondominioId(Long condominioId) {
        this.condominioId = condominioId;
    }

    public Long getCapacidadMaxima() {
        return capacidadMaxima;
    }

    public void setCapacidadMaxima(Long capacidadMaxima) {
        this.capacidadMaxima = capacidadMaxima;
    }
}
