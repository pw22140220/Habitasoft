package com.condominios.repository;

import com.condominios.model.HistorialAcceso;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;

public interface HistorialAccesoRepository extends JpaRepository<HistorialAcceso, Long> {

    Page<HistorialAcceso> findByGuardiaId(Long guardiaId, Pageable pageable);

    Page<HistorialAcceso> findByCondominioId(Long condominioId, Pageable pageable);

    long countByGuardiaIdAndFechaAccesoBetween(Long guardiaId, LocalDateTime start, LocalDateTime end);

    long countByCondominioIdAndFechaAccesoBetween(Long condominioId, LocalDateTime start, LocalDateTime end);
}
