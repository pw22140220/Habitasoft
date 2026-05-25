package com.condominios.dto;

import jakarta.validation.constraints.NotBlank;

public class UnidadRequest {

    @NotBlank
    private String numeroUnidad;

    public String getNumeroUnidad() {
        return numeroUnidad;
    }

    public void setNumeroUnidad(String numeroUnidad) {
        this.numeroUnidad = numeroUnidad;
    }
}
