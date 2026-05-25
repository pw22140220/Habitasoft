package com.condominios.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "Admin_Condominio")
public class AdminCondominio {

    @EmbeddedId
    private AdminCondominioId id = new AdminCondominioId();

    @Column(name = "fecha_asignacion", insertable = false, updatable = false)
    private LocalDateTime fechaAsignacion;

    public AdminCondominio() {}

    public AdminCondominio(Long adminId, Long condominioId) {
        this.id = new AdminCondominioId(adminId, condominioId);
    }

    public AdminCondominioId getId() {
        return id;
    }

    public void setId(AdminCondominioId id) {
        this.id = id;
    }

    public LocalDateTime getFechaAsignacion() {
        return fechaAsignacion;
    }

    public void setFechaAsignacion(LocalDateTime fechaAsignacion) {
        this.fechaAsignacion = fechaAsignacion;
    }

    public Long getCondominioId() {
        return id != null ? id.getCondominioId() : null;
    }

    public Long getAdminId() {
        return id != null ? id.getAdminId() : null;
    }

    @Embeddable
    public static class AdminCondominioId implements Serializable {

        @Column(name = "admin_id")
        private Long adminId;

        @Column(name = "condominio_id")
        private Long condominioId;

        public AdminCondominioId() {}

        public AdminCondominioId(Long adminId, Long condominioId) {
            this.adminId = adminId;
            this.condominioId = condominioId;
        }

        public Long getAdminId() {
            return adminId;
        }

        public void setAdminId(Long adminId) {
            this.adminId = adminId;
        }

        public Long getCondominioId() {
            return condominioId;
        }

        public void setCondominioId(Long condominioId) {
            this.condominioId = condominioId;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            AdminCondominioId that = (AdminCondominioId) o;
            return Objects.equals(adminId, that.adminId) &&
                   Objects.equals(condominioId, that.condominioId);
        }

        @Override
        public int hashCode() {
            return Objects.hash(adminId, condominioId);
        }
    }
}
