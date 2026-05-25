package com.condominios.service;

import com.condominios.dto.PaseDeVisitaRequest;
import com.condominios.dto.PaseDeVisitaResponse;
import com.condominios.model.PaseDeVisita;
import com.condominios.repository.PaseDeVisitaRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.security.SecureRandom;
import java.time.LocalDate;
import java.util.Base64;

@Service
public class PaseDeVisitaService {

    private final PaseDeVisitaRepository paseDeVisitaRepository;

    public PaseDeVisitaService(PaseDeVisitaRepository paseDeVisitaRepository) {
        this.paseDeVisitaRepository = paseDeVisitaRepository;
    }

    @Transactional
    public PaseDeVisitaResponse generar(PaseDeVisitaRequest request, Long residenteId) {
        PaseDeVisita pase = new PaseDeVisita();
        pase.setResidenteId(residenteId);
        pase.setNombreVisitante(request.getNombreVisitante());
        pase.setFechaValidez(LocalDate.now().plusDays(1));
        pase.setEstado(PaseDeVisita.EstadoPase.activo);

        String rawData = residenteId + "|" + request.getNombreVisitante() + "|" + System.currentTimeMillis();
        String qrCode = Base64.getUrlEncoder().withoutPadding().encodeToString(rawData.getBytes());
        pase.setCodigoQr(qrCode);

        PaseDeVisita saved = paseDeVisitaRepository.save(pase);
        return toResponse(saved);
    }

    public Page<PaseDeVisitaResponse> listarMisPases(Long residenteId, Pageable pageable) {
        return paseDeVisitaRepository.findByResidenteId(residenteId, pageable)
                .map(this::toResponse);
    }

    private PaseDeVisitaResponse toResponse(PaseDeVisita pase) {
        PaseDeVisitaResponse response = new PaseDeVisitaResponse();
        response.setId(pase.getId());
        response.setResidenteId(pase.getResidenteId());
        response.setNombreVisitante(pase.getNombreVisitante());
        response.setCodigoQr(pase.getCodigoQr());
        response.setFechaValidez(pase.getFechaValidez());
        response.setEstado(pase.getEstado().name());
        return response;
    }
}
