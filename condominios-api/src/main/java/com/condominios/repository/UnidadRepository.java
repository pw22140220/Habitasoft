package com.condominios.repository;

import com.condominios.model.Unidad;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UnidadRepository extends JpaRepository<Unidad, Long> {

    Optional<Unidad> findByIdAndCondominioId(Long id, Long condominioId);

    List<Unidad> findByCondominioId(Long condominioId);

    boolean existsByNumeroUnidadAndCondominioId(String numeroUnidad, Long condominioId);
}
