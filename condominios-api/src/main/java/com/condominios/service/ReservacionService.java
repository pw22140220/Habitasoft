package com.condominios.service;

import com.condominios.dto.ReservacionRequest;
import com.condominios.dto.ReservacionResponse;
import com.condominios.model.Amenidad;
import com.condominios.model.Reservacion;
import com.condominios.model.User;
import com.condominios.repository.AmenidadRepository;
import com.condominios.repository.ReservacionRepository;
import com.condominios.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
public class ReservacionService {

    private final ReservacionRepository reservacionRepository;
    private final AmenidadRepository amenidadRepository;
    private final UserRepository userRepository;

    public ReservacionService(ReservacionRepository reservacionRepository,
                              AmenidadRepository amenidadRepository,
                              UserRepository userRepository) {
        this.reservacionRepository = reservacionRepository;
        this.amenidadRepository = amenidadRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public ReservacionResponse crear(ReservacionRequest request, Long residenteId) {
        Amenidad amenidad = amenidadRepository.findById(request.getAmenidadId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Amenidad no encontrada"));

        if (request.getFechaHoraInicio().isAfter(request.getFechaHoraFin()) ||
            request.getFechaHoraInicio().isEqual(request.getFechaHoraFin())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "La fecha de inicio debe ser anterior a la fecha de fin");
        }

        if (request.getFechaHoraInicio().isBefore(java.time.LocalDateTime.now())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "No se puede reservar en el pasado");
        }

        var conflictos = reservacionRepository.findConflictos(
                request.getAmenidadId(),
                request.getFechaHoraInicio(),
                request.getFechaHoraFin());

        if (!conflictos.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "Ya existe una reservación en ese horario para esta amenidad");
        }

        Reservacion reservacion = new Reservacion();
        reservacion.setAmenidadId(request.getAmenidadId());
        reservacion.setResidenteId(residenteId);
        reservacion.setFechaHoraInicio(request.getFechaHoraInicio());
        reservacion.setFechaHoraFin(request.getFechaHoraFin());
        reservacion.setEstado(Reservacion.EstadoReservacion.confirmada);

        Reservacion saved = reservacionRepository.save(reservacion);
        return toResponse(saved);
    }

    public Page<ReservacionResponse> listarMisReservaciones(Long residenteId, Pageable pageable) {
        return reservacionRepository.findByResidenteId(residenteId, pageable)
                .map(this::toResponse);
    }

    @Transactional
    public void cancelar(Long id, Long residenteId) {
        Reservacion reservacion = reservacionRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Reservación no encontrada"));

        if (!reservacion.getResidenteId().equals(residenteId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "Esta reservación no pertenece al residente autenticado");
        }

        if (reservacion.getEstado() == Reservacion.EstadoReservacion.cancelada) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "La reservación ya está cancelada");
        }

        reservacion.setEstado(Reservacion.EstadoReservacion.cancelada);
        reservacionRepository.save(reservacion);
    }

    private ReservacionResponse toResponse(Reservacion reservacion) {
        ReservacionResponse response = new ReservacionResponse();
        response.setId(reservacion.getId());
        response.setAmenidadId(reservacion.getAmenidadId());
        response.setResidenteId(reservacion.getResidenteId());
        response.setFechaHoraInicio(reservacion.getFechaHoraInicio());
        response.setFechaHoraFin(reservacion.getFechaHoraFin());
        response.setEstado(reservacion.getEstado().name());

        amenidadRepository.findById(reservacion.getAmenidadId())
                .ifPresent(a -> response.setAmenidadNombre(a.getNombre()));

        userRepository.findById(reservacion.getResidenteId())
                .ifPresent(u -> response.setResidenteNombre(u.getNombre()));

        return response;
    }
}
