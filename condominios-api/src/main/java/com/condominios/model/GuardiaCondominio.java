package com.condominios.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Objects;

@Entity
@Table(name = "Guardia_Condominio")
public class GuardiaCondominio {

    @EmbeddedId
    private GuardiaCondominioId id = new GuardiaCondominioId();

    public GuardiaCondominio() {}

    public GuardiaCondominio(Long guardiaId, Long condominioId) {
        this.id = new GuardiaCondominioId(guardiaId, condominioId);
    }

    public GuardiaCondominioId getId() {
        return id;
    }

    public void setId(GuardiaCondominioId id) {
        this.id = id;
    }

    public Long getCondominioId() {
        return id != null ? id.getCondominioId() : null;
    }

    public Long getGuardiaId() {
        return id != null ? id.getGuardiaId() : null;
    }

    @Embeddable
    public static class GuardiaCondominioId implements Serializable {

        @Column(name = "guardia_id")
        private Long guardiaId;

        @Column(name = "condominio_id")
        private Long condominioId;

        public GuardiaCondominioId() {}

        public GuardiaCondominioId(Long guardiaId, Long condominioId) {
            this.guardiaId = guardiaId;
            this.condominioId = condominioId;
        }

        public Long getGuardiaId() {
            return guardiaId;
        }

        public void setGuardiaId(Long guardiaId) {
            this.guardiaId = guardiaId;
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
            GuardiaCondominioId that = (GuardiaCondominioId) o;
            return Objects.equals(guardiaId, that.guardiaId) &&
                   Objects.equals(condominioId, that.condominioId);
        }

        @Override
        public int hashCode() {
            return Objects.hash(guardiaId, condominioId);
        }
    }
}
