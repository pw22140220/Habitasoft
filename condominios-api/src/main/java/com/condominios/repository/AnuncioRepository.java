package com.condominios.repository;

import com.condominios.model.Anuncio;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;

public interface AnuncioRepository extends JpaRepository<Anuncio, Long> {

    Page<Anuncio> findByCondominioId(Long condominioId, Pageable pageable);

    Page<Anuncio> findByCondominioIdAndActivoTrue(Long condominioId, Pageable pageable);

    Page<Anuncio> findByCondominioIdAndDestacadoTrue(Long condominioId, Pageable pageable);

    @Query("SELECT a FROM Anuncio a WHERE a.condominioId = :condominioId AND a.activo = true " +
           "AND (a.fechaExpiracion IS NULL OR a.fechaExpiracion >= :hoy) " +
           "ORDER BY a.destacado DESC, a.fechaCreacion DESC")
    Page<Anuncio> findActivosParaResidentes(@Param("condominioId") Long condominioId,
                                             @Param("hoy") LocalDate hoy,
                                             Pageable pageable);
}
