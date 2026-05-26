package com.condominios.service;

import com.condominios.dto.AnuncioRequest;
import com.condominios.dto.AnuncioResponse;
import com.condominios.model.Anuncio;
import com.condominios.model.User;
import com.condominios.repository.AnuncioRepository;
import com.condominios.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;

@Service
public class AnuncioService {

    private final AnuncioRepository anuncioRepository;
    private final UserRepository userRepository;

    public AnuncioService(AnuncioRepository anuncioRepository, UserRepository userRepository) {
        this.anuncioRepository = anuncioRepository;
        this.userRepository = userRepository;
    }

    public AnuncioResponse crear(AnuncioRequest request, Long adminId, Long condominioId) {
        Anuncio anuncio = new Anuncio();
        anuncio.setTitulo(request.getTitulo());
        anuncio.setContenido(request.getContenido());
        anuncio.setCondominioId(condominioId);
        anuncio.setCreadoPorId(adminId);
        anuncio.setFechaExpiracion(request.getFechaExpiracion());
        anuncio.setActivo(request.getActivo() != null ? request.getActivo() : true);
        anuncio.setDestacado(request.getDestacado() != null ? request.getDestacado() : false);
        anuncio.setImagenUrl(request.getImagenUrl());
        anuncio.setDestinatario(request.getDestinatario() != null ? request.getDestinatario() : "ambos");
        anuncio = anuncioRepository.save(anuncio);
        return toResponse(anuncio);
    }

    public Page<AnuncioResponse> listarPorCondominio(Long condominioId, Pageable pageable) {
        return anuncioRepository.findByCondominioId(condominioId, pageable)
                .map(this::toResponse);
    }

    public AnuncioResponse obtenerPorId(Long id) {
        Anuncio anuncio = anuncioRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Anuncio no encontrado"));
        return toResponse(anuncio);
    }

    public AnuncioResponse actualizar(Long id, AnuncioRequest request) {
        Anuncio anuncio = anuncioRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Anuncio no encontrado"));
        anuncio.setTitulo(request.getTitulo());
        anuncio.setContenido(request.getContenido());
        anuncio.setFechaExpiracion(request.getFechaExpiracion());
        anuncio.setActivo(request.getActivo() != null ? request.getActivo() : anuncio.getActivo());
        anuncio.setDestacado(request.getDestacado() != null ? request.getDestacado() : anuncio.getDestacado());
        anuncio.setImagenUrl(request.getImagenUrl());
        anuncio.setDestinatario(request.getDestinatario() != null ? request.getDestinatario() : anuncio.getDestinatario());
        anuncio = anuncioRepository.save(anuncio);
        return toResponse(anuncio);
    }

    public void eliminar(Long id) {
        if (!anuncioRepository.existsById(id)) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "Anuncio no encontrado");
        }
        anuncioRepository.deleteById(id);
    }

    public Page<AnuncioResponse> listarActivosParaResidentes(Long condominioId, Pageable pageable) {
        return anuncioRepository.findActivosParaResidentes(condominioId, LocalDate.now(), pageable)
                .map(this::toResponse);
    }

    public Page<AnuncioResponse> listarActivosParaGuardias(Long condominioId, Pageable pageable) {
        return anuncioRepository.findActivosParaGuardias(condominioId, LocalDate.now(), pageable)
                .map(this::toResponse);
    }

    public Page<AnuncioResponse> listarActivosPorDestinatario(Long condominioId, String destinatario, Pageable pageable) {
        return anuncioRepository.findActivosPorDestinatario(condominioId, LocalDate.now(), destinatario, pageable)
                .map(this::toResponse);
    }

    private AnuncioResponse toResponse(Anuncio anuncio) {
        AnuncioResponse response = new AnuncioResponse();
        response.setId(anuncio.getId());
        response.setTitulo(anuncio.getTitulo());
        response.setContenido(anuncio.getContenido());
        response.setCondominioId(anuncio.getCondominioId());
        response.setCreadoPorId(anuncio.getCreadoPorId());
        response.setFechaCreacion(anuncio.getFechaCreacion());
        response.setFechaExpiracion(anuncio.getFechaExpiracion());
        response.setActivo(anuncio.getActivo());
        response.setDestacado(anuncio.getDestacado());
        response.setImagenUrl(anuncio.getImagenUrl());
        response.setDestinatario(anuncio.getDestinatario());

        userRepository.findById(anuncio.getCreadoPorId())
                .ifPresent(u -> response.setCreadorNombre(u.getNombre()));

        return response;
    }
}
