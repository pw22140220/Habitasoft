package com.condominios.dto;

import jakarta.validation.constraints.NotBlank;

public class ValidarQrRequest {

    @NotBlank
    private String codigoQr;

    public ValidarQrRequest() {}

    public String getCodigoQr() { return codigoQr; }
    public void setCodigoQr(String codigoQr) { this.codigoQr = codigoQr; }
}
