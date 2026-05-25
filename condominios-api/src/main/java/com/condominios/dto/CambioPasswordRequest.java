package com.condominios.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class CambioPasswordRequest {

    @NotBlank
    private String passwordActual;

    @NotBlank
    @Size(min = 6)
    private String passwordNueva;

    @NotBlank
    private String confirmarPasswordNueva;

    public String getPasswordActual() {
        return passwordActual;
    }

    public void setPasswordActual(String passwordActual) {
        this.passwordActual = passwordActual;
    }

    public String getPasswordNueva() {
        return passwordNueva;
    }

    public void setPasswordNueva(String passwordNueva) {
        this.passwordNueva = passwordNueva;
    }

    public String getConfirmarPasswordNueva() {
        return confirmarPasswordNueva;
    }

    public void setConfirmarPasswordNueva(String confirmarPasswordNueva) {
        this.confirmarPasswordNueva = confirmarPasswordNueva;
    }
}
