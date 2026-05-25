package com.condominios.repository;

import com.condominios.model.ResidenteUnidad;
import com.condominios.model.ResidenteUnidad.ResidenteUnidadId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface ResidenteUnidadRepository extends JpaRepository<ResidenteUnidad, ResidenteUnidadId> {

    Optional<ResidenteUnidad> findByIdResidenteId(Long residenteId);

    void deleteByIdResidenteId(Long residenteId);

    boolean existsByIdResidenteId(Long residenteId);

    @Query("SELECT COUNT(ru) > 0 FROM ResidenteUnidad ru WHERE ru.id.unidadId = :unidadId")
    boolean existsByUnidadId(@Param("unidadId") Long unidadId);

    @Modifying
    @Query("DELETE FROM ResidenteUnidad ru WHERE ru.id.unidadId = :unidadId")
    void deleteByUnidadId(@Param("unidadId") Long unidadId);
}
