package com.condominios.service;

import com.condominios.dto.IncidenteRequest;
import com.condominios.dto.IncidenteResponse;
import com.condominios.model.Incidente;
import com.condominios.model.Incidente.Estado;
import com.condominios.model.User;
import com.condominios.repository.IncidenteRepository;
import com.condominios.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
public class IncidenteService {

    private final IncidenteRepository incidenteRepository;
    private final UserRepository userRepository;

    public IncidenteService(IncidenteRepository incidenteRepository, UserRepository userRepository) {
        this.incidenteRepository = incidenteRepository;
        this.userRepository = userRepository;
    }

    public IncidenteResponse crear(IncidenteRequest request, Long guardiaId, Long condominioId) {
        Incidente incidente = new Incidente();
        incidente.setReportadoPorId(guardiaId);
        incidente.setCondominioId(condominioId);
        incidente.setTitulo(request.getTitulo());
        incidente.setDescripcion(request.getDescripcion());
        incidente.setTipo(request.getTipo());
        incidente.setUbicacion(request.getUbicacion());
        incidente.setPrioridad(request.getPrioridad());
        incidente.setEstado(Estado.nuevo);
        Incidente saved = incidenteRepository.save(incidente);
        return toResponse(saved);
    }

    public Page<IncidenteResponse> listarTodos(Pageable pageable, Long condominioId) {
        if (condominioId != null) {
            return incidenteRepository.findByCondominioId(condominioId, pageable).map(this::toResponse);
        }
        return incidenteRepository.findAll(pageable).map(this::toResponse);
    }

    public Page<IncidenteResponse> listarPorGuardia(Long guardiaId, Pageable pageable) {
        return incidenteRepository.findByReportadoPorId(guardiaId, pageable).map(this::toResponse);
    }

    public IncidenteResponse obtenerPorId(Long id) {
        Incidente incidente = incidenteRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Incidente no encontrado"));
        return toResponse(incidente);
    }

    public IncidenteResponse actualizar(Long id, IncidenteRequest request, Long usuarioId) {
        Incidente incidente = incidenteRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Incidente no encontrado"));

        if (!incidente.getReportadoPorId().equals(usuarioId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "No puedes editar un incidente de otro guardia");
        }

        incidente.setTitulo(request.getTitulo());
        incidente.setDescripcion(request.getDescripcion());
        incidente.setTipo(request.getTipo());
        incidente.setUbicacion(request.getUbicacion());
        incidente.setPrioridad(request.getPrioridad());
        incidente = incidenteRepository.save(incidente);
        return toResponse(incidente);
    }

    public IncidenteResponse actualizarEstado(Long id, Estado nuevoEstado, Long usuarioId) {
        Incidente incidente = incidenteRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Incidente no encontrado"));

        if (!incidente.getReportadoPorId().equals(usuarioId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "No puedes cambiar el estado de un incidente de otro guardia");
        }

        incidente.setEstado(nuevoEstado);
        incidente = incidenteRepository.save(incidente);
        return toResponse(incidente);
    }

    public void eliminar(Long id, Long usuarioId, String rol) {
        Incidente incidente = incidenteRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Incidente no encontrado"));

        boolean esAdmin = "administrador".equals(rol);
        boolean esPropietario = incidente.getReportadoPorId().equals(usuarioId);

        if (!esAdmin && !esPropietario) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "No tienes permiso para eliminar este incidente");
        }

        incidenteRepository.deleteById(id);
    }

    private IncidenteResponse toResponse(Incidente incidente) {
        String nombreReportador = "";
        try {
            User user = userRepository.findById(incidente.getReportadoPorId()).orElse(null);
            if (user != null) {
                nombreReportador = user.getNombre();
            }
        } catch (Exception e) {
            nombreReportador = "";
        }

        IncidenteResponse response = new IncidenteResponse();
        response.setId(incidente.getId());
        response.setReportadoPorId(incidente.getReportadoPorId());
        response.setCondominioId(incidente.getCondominioId());
        response.setNombreReportador(nombreReportador);
        response.setTitulo(incidente.getTitulo());
        response.setDescripcion(incidente.getDescripcion());
        response.setTipo(incidente.getTipo());
        response.setUbicacion(incidente.getUbicacion());
        response.setPrioridad(incidente.getPrioridad());
        response.setEstado(incidente.getEstado());
        response.setFechaHoraIncidente(incidente.getFechaHoraIncidente());
        response.setFechaActualizacion(incidente.getFechaActualizacion());
        return response;
    }
}
