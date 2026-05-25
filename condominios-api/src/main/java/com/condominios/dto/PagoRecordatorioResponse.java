package com.condominios.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class PagoRecordatorioResponse {

    private Long id;
    private Long residenteId;
    private String residenteNombre;
    private BigDecimal monto;
    private String periodo;
    private LocalDate fechaVencimiento;
    private String estado;
    private LocalDateTime fechaPago;
    private String metodoPago;

    public PagoRecordatorioResponse() {}

    public PagoRecordatorioResponse(Long id, Long residenteId, String residenteNombre,
                                    BigDecimal monto, String periodo, LocalDate fechaVencimiento,
                                    String estado, LocalDateTime fechaPago, String metodoPago) {
        this.id = id;
        this.residenteId = residenteId;
        this.residenteNombre = residenteNombre;
        this.monto = monto;
        this.periodo = periodo;
        this.fechaVencimiento = fechaVencimiento;
        this.estado = estado;
        this.fechaPago = fechaPago;
        this.metodoPago = metodoPago;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getResidenteId() {
        return residenteId;
    }

    public void setResidenteId(Long residenteId) {
        this.residenteId = residenteId;
    }

    public String getResidenteNombre() {
        return residenteNombre;
    }

    public void setResidenteNombre(String residenteNombre) {
        this.residenteNombre = residenteNombre;
    }

    public BigDecimal getMonto() {
        return monto;
    }

    public void setMonto(BigDecimal monto) {
        this.monto = monto;
    }

    public String getPeriodo() {
        return periodo;
    }

    public void setPeriodo(String periodo) {
        this.periodo = periodo;
    }

    public LocalDate getFechaVencimiento() {
        return fechaVencimiento;
    }

    public void setFechaVencimiento(LocalDate fechaVencimiento) {
        this.fechaVencimiento = fechaVencimiento;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public LocalDateTime getFechaPago() {
        return fechaPago;
    }

    public void setFechaPago(LocalDateTime fechaPago) {
        this.fechaPago = fechaPago;
    }

    public String getMetodoPago() {
        return metodoPago;
    }

    public void setMetodoPago(String metodoPago) {
        this.metodoPago = metodoPago;
    }
}
