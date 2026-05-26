package com.condominios.dto;

import jakarta.validation.constraints.NotBlank;
import java.time.LocalDate;

public class PaseDeVisitaRequest {

    @NotBlank
    private String nombreVisitante;

    private LocalDate fechaValidez;

    public PaseDeVisitaRequest() {}

    public String getNombreVisitante() { return nombreVisitante; }
    public void setNombreVisitante(String nombreVisitante) { this.nombreVisitante = nombreVisitante; }

    public LocalDate getFechaValidez() { return fechaValidez; }
    public void setFechaValidez(LocalDate fechaValidez) { this.fechaValidez = fechaValidez; }
}
