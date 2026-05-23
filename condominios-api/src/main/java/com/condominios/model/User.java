package com.condominios.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entidad que mapea la tabla "Usuarios" de la base de datos habitasoft_db.
 *
 * La tabla fue creada con el siguiente DDL:
 * <pre>
 * CREATE TABLE Usuarios (
 *     id INT PRIMARY KEY AUTO_INCREMENT,
 *     nombre VARCHAR(100) NOT NULL,
 *     email VARCHAR(100) UNIQUE NOT NULL,
 *     password_hash VARCHAR(255) NOT NULL,
 *     telefono VARCHAR(20),
 *     rol ENUM('administrador','residente','guardia') NOT NULL,
 *     fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 * );
 * </pre>
 */
@Entity
@Table(name = "Usuarios")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "nombre", nullable = false, length = 100)
    private String nombre;

    @Column(name = "email", nullable = false, unique = true, length = 100)
    private String email;

    @Column(name = "password_hash", nullable = false, length = 255)
    private String passwordHash;

    @Column(name = "telefono", length = 20)
    private String telefono;

    /**
     * Rol del usuario dentro del sistema.
     * Valores posibles: 'administrador', 'residente', 'guardia'
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "rol", nullable = false, columnDefinition = "ENUM('administrador','residente','guardia')")
    private Rol rol;

    @Column(name = "fecha_creacion", insertable = false, updatable = false)
    private LocalDateTime fechaCreacion;

    /**
     * Enumeración que define los roles permitidos en HabitaSoft.
     */
    public enum Rol {
        administrador,
        residente,
        guardia
    }

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

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
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

    public LocalDateTime getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(LocalDateTime fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }
}
