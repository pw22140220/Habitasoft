package com.condominios.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "PasesDeVisita")
public class PaseDeVisita {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "residente_id", nullable = false)
    private Long residenteId;

    @Column(name = "nombre_visitante", length = 100)
    private String nombreVisitante;

    @Column(name = "codigo_qr", length = 255, unique = true)
    private String codigoQr;

    @Column(name = "fecha_validez")
    private LocalDate fechaValidez;

    @Enumerated(EnumType.STRING)
    @Column(name = "estado")
    private EstadoPase estado = EstadoPase.activo;

    @Column(name = "usado_por_id")
    private Long usadoPorId;

    @Column(name = "fecha_uso")
    private LocalDateTime fechaUso;

    @Column(name = "fecha_creacion", insertable = false, updatable = false)
    private LocalDateTime fechaCreacion;

    public enum EstadoPase {
        activo, usado, expirado
    }

    public PaseDeVisita() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getResidenteId() { return residenteId; }
    public void setResidenteId(Long residenteId) { this.residenteId = residenteId; }

    public String getNombreVisitante() { return nombreVisitante; }
    public void setNombreVisitante(String nombreVisitante) { this.nombreVisitante = nombreVisitante; }

    public String getCodigoQr() { return codigoQr; }
    public void setCodigoQr(String codigoQr) { this.codigoQr = codigoQr; }

    public LocalDate getFechaValidez() { return fechaValidez; }
    public void setFechaValidez(LocalDate fechaValidez) { this.fechaValidez = fechaValidez; }

    public EstadoPase getEstado() { return estado; }
    public void setEstado(EstadoPase estado) { this.estado = estado; }

    public Long getUsadoPorId() { return usadoPorId; }
    public void setUsadoPorId(Long usadoPorId) { this.usadoPorId = usadoPorId; }

    public LocalDateTime getFechaUso() { return fechaUso; }
    public void setFechaUso(LocalDateTime fechaUso) { this.fechaUso = fechaUso; }

    public LocalDateTime getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(LocalDateTime fechaCreacion) { this.fechaCreacion = fechaCreacion; }
}
