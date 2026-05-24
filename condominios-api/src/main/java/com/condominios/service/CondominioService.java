package com.condominios.service;

import com.condominios.dto.CondominioRequest;
import com.condominios.dto.CondominioResponse;
import com.condominios.model.Condominio;
import com.condominios.repository.CondominioRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
public class CondominioService {

    private final CondominioRepository condominioRepository;

    public CondominioService(CondominioRepository condominioRepository) {
        this.condominioRepository = condominioRepository;
    }

    public CondominioResponse crear(CondominioRequest request) {
        Condominio condominio = new Condominio();
        condominio.setNombre(request.getNombre());
        condominio.setDireccion(request.getDireccion());
        condominio = condominioRepository.save(condominio);
        return toResponse(condominio);
    }

    public Page<CondominioResponse> listar(Pageable pageable) {
        return condominioRepository.findAll(pageable)
                .map(this::toResponse);
    }

    public CondominioResponse obtenerPorId(Long id) {
        Condominio condominio = condominioRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Condominio no encontrado"));
        return toResponse(condominio);
    }

    public CondominioResponse actualizar(Long id, CondominioRequest request) {
        Condominio condominio = condominioRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Condominio no encontrado"));
        condominio.setNombre(request.getNombre());
        condominio.setDireccion(request.getDireccion());
        condominio = condominioRepository.save(condominio);
        return toResponse(condominio);
    }

    public void eliminar(Long id) {
        if (!condominioRepository.existsById(id)) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "Condominio no encontrado");
        }
        condominioRepository.deleteById(id);
    }

    private CondominioResponse toResponse(Condominio condominio) {
        CondominioResponse response = new CondominioResponse();
        response.setId(condominio.getId());
        response.setNombre(condominio.getNombre());
        response.setDireccion(condominio.getDireccion());
        response.setFechaCreacion(condominio.getFechaCreacion());
        return response;
    }
}
