package com.condominios.controller;

import com.condominios.dto.UnidadRequest;
import com.condominios.dto.UnidadResponse;
import com.condominios.model.Unidad;
import com.condominios.repository.ResidenteUnidadRepository;
import com.condominios.repository.UnidadRepository;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/api/admin/unidades")
@CrossOrigin(origins = "*")
@PreAuthorize("hasRole('ADMINISTRADOR')")
public class UnidadController {

    private final UnidadRepository unidadRepository;
    private final ResidenteUnidadRepository residenteUnidadRepository;

    public UnidadController(UnidadRepository unidadRepository,
                            ResidenteUnidadRepository residenteUnidadRepository) {
        this.unidadRepository = unidadRepository;
        this.residenteUnidadRepository = residenteUnidadRepository;
    }

    @GetMapping
    public ResponseEntity<List<Unidad>> listarPorCondominio(
            @RequestParam("condominioId") Long condominioId) {
        return ResponseEntity.ok(unidadRepository.findByCondominioId(condominioId));
    }

    @PostMapping
    public ResponseEntity<UnidadResponse> crear(@Valid @RequestBody UnidadRequest request,
                                                 @RequestParam("condominioId") Long condominioId) {
        if (unidadRepository.existsByNumeroUnidadAndCondominioId(
                request.getNumeroUnidad(), condominioId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "La unidad '" + request.getNumeroUnidad() + "' ya existe en este condominio");
        }

        Unidad unidad = new Unidad();
        unidad.setCondominioId(condominioId);
        unidad.setNumeroUnidad(request.getNumeroUnidad());
        unidad = unidadRepository.save(unidad);

        return ResponseEntity.status(HttpStatus.CREATED).body(toResponse(unidad));
    }

    @PutMapping("/{id}")
    public ResponseEntity<UnidadResponse> actualizar(@PathVariable("id") Long id,
                                                      @Valid @RequestBody UnidadRequest request,
                                                      @RequestParam("condominioId") Long condominioId) {
        Unidad unidad = unidadRepository.findByIdAndCondominioId(id, condominioId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Unidad no encontrada"));

        String nuevoNumero = request.getNumeroUnidad();
        if (!unidad.getNumeroUnidad().equals(nuevoNumero)
                && unidadRepository.existsByNumeroUnidadAndCondominioId(nuevoNumero, condominioId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "La unidad '" + nuevoNumero + "' ya existe en este condominio");
        }

        unidad.setNumeroUnidad(nuevoNumero);
        unidad = unidadRepository.save(unidad);

        return ResponseEntity.ok(toResponse(unidad));
    }

    @Transactional
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable("id") Long id) {
        Unidad unidad = unidadRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Unidad no encontrada"));

        if (residenteUnidadRepository.existsByUnidadId(id)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Esta unidad tiene residentes asignados y no se puede eliminar. "
                    + "Primero edita los residentes para asignarles otra unidad, y luego intenta eliminar esta.");
        }

        unidadRepository.delete(unidad);
        return ResponseEntity.noContent().build();
    }

    private UnidadResponse toResponse(Unidad unidad) {
        UnidadResponse response = new UnidadResponse();
        response.setId(unidad.getId());
        response.setNumeroUnidad(unidad.getNumeroUnidad());
        response.setCondominioId(unidad.getCondominioId());
        return response;
    }
}
