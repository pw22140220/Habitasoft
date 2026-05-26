package com.condominios.dto;

import java.time.LocalDate;

public class ValidarQrResponse {

    private boolean valido;
    private String mensaje;
    private String nombreVisitante;
    private String residenteNombre;
    private String unidad;
    private LocalDate fechaValidez;

    public ValidarQrResponse() {}

    public boolean isValido() { return valido; }
    public void setValido(boolean valido) { this.valido = valido; }

    public String getMensaje() { return mensaje; }
    public void setMensaje(String mensaje) { this.mensaje = mensaje; }

    public String getNombreVisitante() { return nombreVisitante; }
    public void setNombreVisitante(String nombreVisitante) { this.nombreVisitante = nombreVisitante; }

    public String getResidenteNombre() { return residenteNombre; }
    public void setResidenteNombre(String residenteNombre) { this.residenteNombre = residenteNombre; }

    public String getUnidad() { return unidad; }
    public void setUnidad(String unidad) { this.unidad = unidad; }

    public LocalDate getFechaValidez() { return fechaValidez; }
    public void setFechaValidez(LocalDate fechaValidez) { this.fechaValidez = fechaValidez; }
}
