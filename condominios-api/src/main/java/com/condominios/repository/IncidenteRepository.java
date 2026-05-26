package com.condominios.repository;

import com.condominios.model.Incidente;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IncidenteRepository extends JpaRepository<Incidente, Long> {

    Page<Incidente> findByReportadoPorId(Long reportadoPorId, Pageable pageable);

    Page<Incidente> findByCondominioId(Long condominioId, Pageable pageable);
}
