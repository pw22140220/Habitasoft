package com.condominios.repository;

import com.condominios.model.Alerta;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;

public interface AlertaRepository extends JpaRepository<Alerta, Long> {

    Page<Alerta> findByCondominioIdAndActivaTrue(Long condominioId, Pageable pageable);

    @Query("SELECT a FROM Alerta a WHERE a.condominioId = :condominioId AND a.activa = true AND (a.fechaExpiracion IS NULL OR a.fechaExpiracion > :now)")
    Page<Alerta> findActivasNoExpiradasByCondominio(@Param("condominioId") Long condominioId, @Param("now") LocalDateTime now, Pageable pageable);

    Page<Alerta> findByCondominioId(Long condominioId, Pageable pageable);
}
