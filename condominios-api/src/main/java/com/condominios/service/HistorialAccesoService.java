package com.condominios.service;

import com.condominios.dto.HistorialAccesoResponse;
import com.condominios.model.Condominio;
import com.condominios.model.HistorialAcceso;
import com.condominios.model.ResidenteUnidad;
import com.condominios.model.Unidad;
import com.condominios.model.User;
import com.condominios.repository.CondominioRepository;
import com.condominios.repository.HistorialAccesoRepository;
import com.condominios.repository.ResidenteUnidadRepository;
import com.condominios.repository.UnidadRepository;
import com.condominios.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.Map;

@Service
public class HistorialAccesoService {

    private final HistorialAccesoRepository historialAccesoRepository;
    private final CondominioRepository condominioRepository;
    private final UserRepository userRepository;
    private final ResidenteUnidadRepository residenteUnidadRepository;
    private final UnidadRepository unidadRepository;

    public HistorialAccesoService(HistorialAccesoRepository historialAccesoRepository,
                                   CondominioRepository condominioRepository,
                                   UserRepository userRepository,
                                   ResidenteUnidadRepository residenteUnidadRepository,
                                   UnidadRepository unidadRepository) {
        this.historialAccesoRepository = historialAccesoRepository;
        this.condominioRepository = condominioRepository;
        this.userRepository = userRepository;
        this.residenteUnidadRepository = residenteUnidadRepository;
        this.unidadRepository = unidadRepository;
    }

    public Page<HistorialAccesoResponse> listarPorGuardia(Long guardiaId, Pageable pageable) {
        return historialAccesoRepository.findByGuardiaId(guardiaId, pageable)
                .map(this::toResponse);
    }

    public Page<HistorialAccesoResponse> listarPorAdmin(Long condominioId, Pageable pageable) {
        condominioRepository.findById(condominioId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Condominio no encontrado"));

        return historialAccesoRepository.findByCondominioId(condominioId, pageable)
                .map(this::toResponse);
    }

    public Map<String, Object> obtenerEstadisticasGuardia(Long guardiaId) {
        LocalDateTime hoy = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);
        long accesosHoy = historialAccesoRepository.countByGuardiaIdAndFechaAccesoBetween(
                guardiaId, hoy, LocalDateTime.now());
        return Map.of("accesosHoy", accesosHoy);
    }

    public Map<String, Object> obtenerEstadisticasAdmin(Long condominioId) {
        condominioRepository.findById(condominioId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Condominio no encontrado"));

        LocalDateTime hoy = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);
        LocalDateTime inicioSemana = hoy.minusDays(7);
        LocalDateTime inicioMes = hoy.withDayOfMonth(1);

        return Map.of(
                "accesosHoy", historialAccesoRepository.countByCondominioIdAndFechaAccesoBetween(
                        condominioId, hoy, LocalDateTime.now()),
                "accesosSemana", historialAccesoRepository.countByCondominioIdAndFechaAccesoBetween(
                        condominioId, inicioSemana, LocalDateTime.now()),
                "accesosMes", historialAccesoRepository.countByCondominioIdAndFechaAccesoBetween(
                        condominioId, inicioMes, LocalDateTime.now())
        );
    }

    private HistorialAccesoResponse toResponse(HistorialAcceso historial) {
        HistorialAccesoResponse response = new HistorialAccesoResponse();
        response.setId(historial.getId());
        response.setPaseVisitaId(historial.getPaseVisitaId());
        response.setGuardiaId(historial.getGuardiaId());
        response.setResidenteId(historial.getResidenteId());
        response.setNombreVisitante(historial.getNombreVisitante());
        response.setCodigoQr(historial.getCodigoQr());
        response.setFechaAcceso(historial.getFechaAcceso());
        response.setCondominioId(historial.getCondominioId());

        userRepository.findById(historial.getGuardiaId())
                .ifPresent(g -> response.setGuardiaNombre(g.getNombre()));

        userRepository.findById(historial.getResidenteId())
                .ifPresent(r -> {
                    response.setResidenteNombre(r.getNombre());
                });

        residenteUnidadRepository.findByIdResidenteId(historial.getResidenteId())
                .map(ResidenteUnidad::getId)
                .map(ResidenteUnidad.ResidenteUnidadId::getUnidadId)
                .flatMap(unidadId -> unidadRepository.findById(unidadId))
                .map(Unidad::getNumeroUnidad)
                .ifPresent(response::setUnidadNumero);

        return response;
    }
}
