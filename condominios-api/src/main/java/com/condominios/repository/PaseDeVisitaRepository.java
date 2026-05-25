package com.condominios.repository;

import com.condominios.model.PaseDeVisita;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PaseDeVisitaRepository extends JpaRepository<PaseDeVisita, Long> {

    Page<PaseDeVisita> findByResidenteId(Long residenteId, Pageable pageable);

    Optional<PaseDeVisita> findByCodigoQr(String codigoQr);
}
