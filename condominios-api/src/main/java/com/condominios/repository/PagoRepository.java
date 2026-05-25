package com.condominios.repository;

import com.condominios.model.Pago;
import com.condominios.model.Pago.Estado;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface PagoRepository extends JpaRepository<Pago, Long> {

    Page<Pago> findByResidenteId(Long residenteId, Pageable pageable);

    Page<Pago> findByEstado(Estado estado, Pageable pageable);

    @Query("SELECT p FROM Pago p WHERE p.residenteId IN " +
           "(SELECT ru.id.residenteId FROM ResidenteUnidad ru " +
           "JOIN Unidad u ON u.id = ru.id.unidadId " +
           "WHERE u.condominioId = :condominioId) " +
           "ORDER BY p.id DESC")
    Page<Pago> findByCondominioId(@Param("condominioId") Long condominioId, Pageable pageable);

    @Query("SELECT p FROM Pago p WHERE p.residenteId = :residenteId AND p.residenteId IN " +
           "(SELECT ru.id.residenteId FROM ResidenteUnidad ru " +
           "JOIN Unidad u ON u.id = ru.id.unidadId " +
           "WHERE u.condominioId = :condominioId) " +
           "ORDER BY p.id DESC")
    Page<Pago> findByResidenteIdAndCondominioId(@Param("residenteId") Long residenteId,
                                                 @Param("condominioId") Long condominioId,
                                                 Pageable pageable);

    @Query("SELECT p FROM Pago p WHERE p.estado = 'pendiente' AND p.fechaVencimiento IS NOT NULL AND p.fechaVencimiento < :hoy")
    List<Pago> findVencidos(@Param("hoy") LocalDate hoy);

    @Query("SELECT p FROM Pago p WHERE p.residenteId IN " +
           "(SELECT ru.id.residenteId FROM ResidenteUnidad ru " +
           "JOIN Unidad u ON u.id = ru.id.unidadId " +
           "WHERE u.condominioId = :condominioId) " +
           "AND p.estado = :estado ORDER BY p.id DESC")
    Page<Pago> findByCondominioIdAndEstado(@Param("condominioId") Long condominioId,
                                            @Param("estado") Estado estado,
                                            Pageable pageable);

    @Modifying
    @Query("UPDATE Pago p SET p.estado = 'vencido' WHERE p.estado = 'pendiente' AND p.fechaVencimiento IS NOT NULL AND p.fechaVencimiento < :hoy")
    int marcarVencidos(@Param("hoy") LocalDate hoy);
}
