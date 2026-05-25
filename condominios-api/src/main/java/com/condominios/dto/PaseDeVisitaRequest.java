package com.condominios.dto;

import jakarta.validation.constraints.NotBlank;

public class PaseDeVisitaRequest {

    @NotBlank
    private String nombreVisitante;

    public PaseDeVisitaRequest() {}

    public String getNombreVisitante() { return nombreVisitante; }
    public void setNombreVisitante(String nombreVisitante) { this.nombreVisitante = nombreVisitante; }
}
