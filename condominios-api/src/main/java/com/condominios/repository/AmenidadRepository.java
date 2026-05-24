package com.condominios.repository;

import com.condominios.model.Amenidad;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AmenidadRepository extends JpaRepository<Amenidad, Long> {

    Page<Amenidad> findByCondominioId(Long condominioId, Pageable pageable);
}
