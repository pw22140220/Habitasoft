package com.condominios.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "Alertas")
public class Alerta {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "titulo", nullable = false, length = 100)
    private String titulo;

    @Column(name = "mensaje", nullable = false, columnDefinition = "TEXT")
    private String mensaje;

    @Enumerated(EnumType.STRING)
    @Column(name = "prioridad", nullable = false)
    private Prioridad prioridad;

    @Column(name = "condominio_id", nullable = false)
    private Long condominioId;

    @Column(name = "creado_por_id", nullable = false)
    private Long creadoPorId;

    @Column(name = "fecha_creacion", insertable = false, updatable = false)
    private LocalDateTime fechaCreacion;

    @Column(name = "fecha_expiracion")
    private LocalDateTime fechaExpiracion;

    @Column(name = "activa")
    private Boolean activa = true;

    public enum Prioridad {
        ALTA, MEDIA, BAJA
    }

    // Constructor por defecto
    public Alerta() {}

    // Constructor con todos los campos
    public Alerta(Long id, String titulo, String mensaje, Prioridad prioridad, 
                  Long condominioId, Long creadoPorId, LocalDateTime fechaCreacion, 
                  LocalDateTime fechaExpiracion, Boolean activa) {
        this.id = id;
        this.titulo = titulo;
        this.mensaje = mensaje;
        this.prioridad = prioridad;
        this.condominioId = condominioId;
        this.creadoPorId = creadoPorId;
        this.fechaCreacion = fechaCreacion;
        this.fechaExpiracion = fechaExpiracion;
        this.activa = activa;
    }

    // Getters y Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public Prioridad getPrioridad() {
        return prioridad;
    }

    public void setPrioridad(Prioridad prioridad) {
        this.prioridad = prioridad;
    }

    public Long getCondominioId() {
        return condominioId;
    }

    public void setCondominioId(Long condominioId) {
        this.condominioId = condominioId;
    }

    public Long getCreadoPorId() {
        return creadoPorId;
    }

    public void setCreadoPorId(Long creadoPorId) {
        this.creadoPorId = creadoPorId;
    }

    public LocalDateTime getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(LocalDateTime fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public LocalDateTime getFechaExpiracion() {
        return fechaExpiracion;
    }

    public void setFechaExpiracion(LocalDateTime fechaExpiracion) {
        this.fechaExpiracion = fechaExpiracion;
    }

    public Boolean getActiva() {
        return activa;
    }

    public void setActiva(Boolean activa) {
        this.activa = activa;
    }

    public boolean isExpirada() {
        return fechaExpiracion != null && fechaExpiracion.isBefore(LocalDateTime.now());
    }
}