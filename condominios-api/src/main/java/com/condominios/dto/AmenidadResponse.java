package com.condominios.dto;

public class AmenidadResponse {

    private Long id;
    private String nombre;
    private Long capacidadMaxima;
    private Long condominioId;

    public AmenidadResponse() {}

    public AmenidadResponse(Long id, String nombre, Long capacidadMaxima, Long condominioId) {
        this.id = id;
        this.nombre = nombre;
        this.capacidadMaxima = capacidadMaxima;
        this.condominioId = condominioId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Long getCapacidadMaxima() {
        return capacidadMaxima;
    }

    public void setCapacidadMaxima(Long capacidadMaxima) {
        this.capacidadMaxima = capacidadMaxima;
    }

    public Long getCondominioId() {
        return condominioId;
    }

    public void setCondominioId(Long condominioId) {
        this.condominioId = condominioId;
    }
}
