package com.condominios.service;

import com.condominios.dto.PaseDeVisitaRequest;
import com.condominios.dto.PaseDeVisitaResponse;
import com.condominios.dto.ValidarQrRequest;
import com.condominios.dto.ValidarQrResponse;
import com.condominios.model.HistorialAcceso;
import com.condominios.model.PaseDeVisita;
import com.condominios.model.PaseDeVisita.EstadoPase;
import com.condominios.model.User;
import com.condominios.model.Unidad;
import com.condominios.repository.GuardiaCondominioRepository;
import com.condominios.repository.HistorialAccesoRepository;
import com.condominios.repository.PaseDeVisitaRepository;
import com.condominios.repository.ResidenteUnidadRepository;
import com.condominios.repository.UnidadRepository;
import com.condominios.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Service
public class PaseDeVisitaService {

    private final PaseDeVisitaRepository paseDeVisitaRepository;
    private final GuardiaCondominioRepository guardiaCondominioRepository;
    private final ResidenteUnidadRepository residenteUnidadRepository;
    private final UnidadRepository unidadRepository;
    private final UserRepository userRepository;
    private final HistorialAccesoRepository historialAccesoRepository;

    public PaseDeVisitaService(PaseDeVisitaRepository paseDeVisitaRepository,
                                GuardiaCondominioRepository guardiaCondominioRepository,
                                ResidenteUnidadRepository residenteUnidadRepository,
                                UnidadRepository unidadRepository,
                                UserRepository userRepository,
                                HistorialAccesoRepository historialAccesoRepository) {
        this.paseDeVisitaRepository = paseDeVisitaRepository;
        this.guardiaCondominioRepository = guardiaCondominioRepository;
        this.residenteUnidadRepository = residenteUnidadRepository;
        this.unidadRepository = unidadRepository;
        this.userRepository = userRepository;
        this.historialAccesoRepository = historialAccesoRepository;
    }

    @Transactional
    public PaseDeVisitaResponse generar(PaseDeVisitaRequest request, Long residenteId) {
        PaseDeVisita pase = new PaseDeVisita();
        pase.setResidenteId(residenteId);
        pase.setNombreVisitante(request.getNombreVisitante());
        pase.setFechaValidez(request.getFechaValidez() != null ? request.getFechaValidez() : LocalDate.now().plusDays(1));
        pase.setEstado(EstadoPase.activo);
        pase.setCodigoQr(UUID.randomUUID().toString());

        PaseDeVisita saved = paseDeVisitaRepository.save(pase);
        return toResponse(saved);
    }

    public Page<PaseDeVisitaResponse> listarMisPases(Long residenteId, Pageable pageable) {
        return paseDeVisitaRepository.findByResidenteId(residenteId, pageable)
                .map(this::toResponse);
    }

    @Transactional
    public ValidarQrResponse validarQr(ValidarQrRequest request, Long guardiaId) {
        PaseDeVisita pase = paseDeVisitaRepository.findByCodigoQr(request.getCodigoQr())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "QR no válido"));

        if (pase.getEstado() != EstadoPase.activo) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Este QR ya fue usado o está expirado");
        }

        if (pase.getFechaValidez().isBefore(LocalDate.now())) {
            pase.setEstado(EstadoPase.expirado);
            paseDeVisitaRepository.save(pase);
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "El QR ha expirado");
        }

        Long condominioGuardia = guardiaCondominioRepository.findFirstByGuardiaId(guardiaId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.FORBIDDEN, "Guardia sin condominio asignado"))
                .getCondominioId();

        Long condominioResidente = residenteUnidadRepository.findCondominioIdByResidenteId(pase.getResidenteId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.FORBIDDEN, "Residente sin unidad asignada"));

        if (!condominioGuardia.equals(condominioResidente)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Este QR no pertenece a su condominio");
        }

        pase.setEstado(EstadoPase.usado);
        pase.setUsadoPorId(guardiaId);
        pase.setFechaUso(LocalDateTime.now());
        paseDeVisitaRepository.save(pase);

        User residente = userRepository.findById(pase.getResidenteId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Residente no encontrado"));

        Unidad unidad = unidadRepository.findById(
                residenteUnidadRepository.findByIdResidenteId(pase.getResidenteId())
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unidad no encontrada"))
                        .getId().getUnidadId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unidad no encontrada"));

        HistorialAcceso historial = new HistorialAcceso();
        historial.setPaseVisitaId(pase.getId());
        historial.setGuardiaId(guardiaId);
        historial.setResidenteId(pase.getResidenteId());
        historial.setNombreVisitante(pase.getNombreVisitante());
        historial.setCodigoQr(pase.getCodigoQr());
        historial.setCondominioId(condominioResidente);
        historialAccesoRepository.save(historial);

        ValidarQrResponse response = new ValidarQrResponse();
        response.setValido(true);
        response.setMensaje("Acceso permitido");
        response.setNombreVisitante(pase.getNombreVisitante());
        response.setResidenteNombre(residente.getNombre());
        response.setUnidad(unidad.getNumeroUnidad());
        response.setFechaValidez(pase.getFechaValidez());
        return response;
    }

    private PaseDeVisitaResponse toResponse(PaseDeVisita pase) {
        PaseDeVisitaResponse response = new PaseDeVisitaResponse();
        response.setId(pase.getId());
        response.setResidenteId(pase.getResidenteId());
        response.setNombreVisitante(pase.getNombreVisitante());
        response.setCodigoQr(pase.getCodigoQr());
        response.setFechaValidez(pase.getFechaValidez());
        response.setEstado(pase.getEstado().name());
        response.setFechaCreacion(pase.getFechaCreacion());
        return response;
    }
}
