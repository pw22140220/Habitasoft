package com.condominios.dto;

import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;

public class PagoRecordatorioRequest {

    @NotNull
    private Long residenteId;

    @NotNull
    private BigDecimal monto;

    private String periodo;

    private LocalDate fechaVencimiento;

    public PagoRecordatorioRequest() {}

    public PagoRecordatorioRequest(Long residenteId, BigDecimal monto, String periodo, LocalDate fechaVencimiento) {
        this.residenteId = residenteId;
        this.monto = monto;
        this.periodo = periodo;
        this.fechaVencimiento = fechaVencimiento;
    }

    public Long getResidenteId() {
        return residenteId;
    }

    public void setResidenteId(Long residenteId) {
        this.residenteId = residenteId;
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
}
