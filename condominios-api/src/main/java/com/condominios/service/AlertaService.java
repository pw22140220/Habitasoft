package com.condominios.service;

import com.condominios.dto.AlertaRequest;
import com.condominios.dto.AlertaResponse;
import com.condominios.model.Alerta;
import com.condominios.repository.AlertaRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;

@Service
public class AlertaService {

    private final AlertaRepository alertaRepository;

    public AlertaService(AlertaRepository alertaRepository) {
        this.alertaRepository = alertaRepository;
    }

    public AlertaResponse crear(AlertaRequest request, Long adminId) {
        Alerta alerta = new Alerta();
        alerta.setTitulo(request.getTitulo());
        alerta.setMensaje(request.getMensaje());
        alerta.setPrioridad(request.getPrioridad());
        alerta.setCondominioId(request.getCondominioId());
        alerta.setCreadoPorId(adminId);
        alerta.setFechaExpiracion(request.getFechaExpiracion());
        alerta.setActiva(true);
        Alerta saved = alertaRepository.save(alerta);
        return toResponse(saved);
    }

    public Page<AlertaResponse> listarTodas(Pageable pageable, Long condominioId) {
        if (condominioId != null) {
            return alertaRepository.findByCondominioId(condominioId, pageable)
                    .map(this::toResponse);
        }
        return alertaRepository.findAll(pageable)
                .map(this::toResponse);
    }

    public AlertaResponse obtenerPorId(Long id) {
        Alerta alerta = alertaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Alerta no encontrada"));
        return toResponse(alerta);
    }

    public AlertaResponse actualizar(Long id, AlertaRequest request) {
        Alerta alerta = alertaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Alerta no encontrada"));
        alerta.setTitulo(request.getTitulo());
        alerta.setMensaje(request.getMensaje());
        alerta.setPrioridad(request.getPrioridad());
        alerta.setCondominioId(request.getCondominioId());
        alerta.setFechaExpiracion(request.getFechaExpiracion());
        alerta = alertaRepository.save(alerta);
        return toResponse(alerta);
    }

    public void eliminar(Long id) {
        if (!alertaRepository.existsById(id)) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "Alerta no encontrada");
        }
        alertaRepository.deleteById(id);
    }

    public Page<AlertaResponse> listarActivasPorCondominio(Long condominioId, Pageable pageable) {
        return alertaRepository.findActivasNoExpiradasByCondominio(condominioId, LocalDateTime.now(), pageable)
                .map(this::toResponse);
    }

    private AlertaResponse toResponse(Alerta alerta) {
        AlertaResponse response = new AlertaResponse();
        response.setId(alerta.getId());
        response.setTitulo(alerta.getTitulo());
        response.setMensaje(alerta.getMensaje());
        response.setPrioridad(alerta.getPrioridad());
        response.setCondominioId(alerta.getCondominioId());
        response.setCreadoPorId(alerta.getCreadoPorId());
        response.setFechaCreacion(alerta.getFechaCreacion());
        response.setFechaExpiracion(alerta.getFechaExpiracion());
        response.setActiva(alerta.getActiva());
        return response;
    }
}