package com.condominios.dto;

import com.condominios.model.User.Rol;

/**
 * DTO que expone los datos públicos de un usuario al frontend.
 * No incluye password_hash por seguridad.
 */
public class UserDto {

    private Long id;
    private String nombre;
    private String email;
    private String telefono;
    private Rol rol;

    // ====== GETTERS Y SETTERS ======

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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public Rol getRol() {
        return rol;
    }

    public void setRol(Rol rol) {
        this.rol = rol;
    }
}
