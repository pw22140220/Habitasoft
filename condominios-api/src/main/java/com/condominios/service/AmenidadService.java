package com.condominios.service;

import com.condominios.dto.AmenidadRequest;
import com.condominios.dto.AmenidadResponse;
import com.condominios.model.Amenidad;
import com.condominios.repository.AmenidadRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
public class AmenidadService {

    private final AmenidadRepository amenidadRepository;

    public AmenidadService(AmenidadRepository amenidadRepository) {
        this.amenidadRepository = amenidadRepository;
    }

    public AmenidadResponse crear(AmenidadRequest request) {
        Amenidad amenidad = new Amenidad();
        amenidad.setNombre(request.getNombre());
        amenidad.setCondominioId(request.getCondominioId());
        amenidad.setCapacidadMaxima(request.getCapacidadMaxima());
        Amenidad saved = amenidadRepository.save(amenidad);
        return toResponse(saved);
    }

    public Page<AmenidadResponse> listarPorCondominio(Long condominioId, Pageable pageable) {
        return amenidadRepository.findByCondominioId(condominioId, pageable)
                .map(this::toResponse);
    }

    public AmenidadResponse obtenerPorId(Long id) {
        Amenidad amenidad = amenidadRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Amenidad no encontrada"));
        return toResponse(amenidad);
    }

    public AmenidadResponse actualizar(Long id, AmenidadRequest request) {
        Amenidad amenidad = amenidadRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Amenidad no encontrada"));
        amenidad.setNombre(request.getNombre());
        amenidad.setCondominioId(request.getCondominioId());
        amenidad.setCapacidadMaxima(request.getCapacidadMaxima());
        amenidad = amenidadRepository.save(amenidad);
        return toResponse(amenidad);
    }

    public void eliminar(Long id) {
        if (!amenidadRepository.existsById(id)) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "Amenidad no encontrada");
        }
        amenidadRepository.deleteById(id);
    }

    private AmenidadResponse toResponse(Amenidad amenidad) {
        AmenidadResponse response = new AmenidadResponse();
        response.setId(amenidad.getId());
        response.setNombre(amenidad.getNombre());
        response.setCapacidadMaxima(amenidad.getCapacidadMaxima());
        response.setCondominioId(amenidad.getCondominioId());
        return response;
    }
}
