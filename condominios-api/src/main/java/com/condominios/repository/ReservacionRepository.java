package com.condominios.repository;

import com.condominios.model.Reservacion;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface ReservacionRepository extends JpaRepository<Reservacion, Long> {

    Page<Reservacion> findByResidenteId(Long residenteId, Pageable pageable);

    List<Reservacion> findByAmenidadIdAndEstadoNot(Long amenidadId, String estado);

    @Query("SELECT r FROM Reservacion r WHERE r.amenidadId = :amenidadId AND r.estado IN ('confirmada', 'pendiente') " +
           "AND r.fechaHoraInicio < :fin AND :inicio < r.fechaHoraFin")
    List<Reservacion> findConflictos(@Param("amenidadId") Long amenidadId,
                                     @Param("inicio") LocalDateTime inicio,
                                     @Param("fin") LocalDateTime fin);
}
