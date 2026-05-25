package com.condominios.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Objects;

@Entity
@Table(name = "Residente_Unidad")
public class ResidenteUnidad {

    @EmbeddedId
    private ResidenteUnidadId id = new ResidenteUnidadId();

    public ResidenteUnidad() {}

    public ResidenteUnidad(Long residenteId, Long unidadId) {
        this.id = new ResidenteUnidadId(residenteId, unidadId);
    }

    public ResidenteUnidadId getId() {
        return id;
    }

    public void setId(ResidenteUnidadId id) {
        this.id = id;
    }

    @Embeddable
    public static class ResidenteUnidadId implements Serializable {

        @Column(name = "residente_id")
        private Long residenteId;

        @Column(name = "unidad_id")
        private Long unidadId;

        public ResidenteUnidadId() {}

        public ResidenteUnidadId(Long residenteId, Long unidadId) {
            this.residenteId = residenteId;
            this.unidadId = unidadId;
        }

        public Long getResidenteId() {
            return residenteId;
        }

        public void setResidenteId(Long residenteId) {
            this.residenteId = residenteId;
        }

        public Long getUnidadId() {
            return unidadId;
        }

        public void setUnidadId(Long unidadId) {
            this.unidadId = unidadId;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            ResidenteUnidadId that = (ResidenteUnidadId) o;
            return Objects.equals(residenteId, that.residenteId) &&
                   Objects.equals(unidadId, that.unidadId);
        }

        @Override
        public int hashCode() {
            return Objects.hash(residenteId, unidadId);
        }
    }
}
