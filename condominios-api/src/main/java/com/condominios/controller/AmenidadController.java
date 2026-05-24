package com.condominios.controller;

import com.condominios.dto.AmenidadRequest;
import com.condominios.dto.AmenidadResponse;
import com.condominios.service.AmenidadService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin(origins = "*")
public class AmenidadController {

    private final AmenidadService amenidadService;

    public AmenidadController(AmenidadService amenidadService) {
        this.amenidadService = amenidadService;
    }

    @PostMapping("/api/admin/amenidades")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<AmenidadResponse> crear(@Valid @RequestBody AmenidadRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(amenidadService.crear(request));
    }

    @GetMapping("/api/admin/amenidades")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<Page<AmenidadResponse>> listarAdmin(
            @RequestParam("condominioId") Long condominioId,
            @PageableDefault(size = 10) Pageable pageable) {
        return ResponseEntity.ok(amenidadService.listarPorCondominio(condominioId, pageable));
    }

    @GetMapping("/api/admin/amenidades/{id}")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<AmenidadResponse> obtenerPorId(@PathVariable("id") Long id) {
        return ResponseEntity.ok(amenidadService.obtenerPorId(id));
    }

    @PutMapping("/api/admin/amenidades/{id}")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<AmenidadResponse> actualizar(@PathVariable("id") Long id,
                                                        @Valid @RequestBody AmenidadRequest request) {
        return ResponseEntity.ok(amenidadService.actualizar(id, request));
    }

    @DeleteMapping("/api/admin/amenidades/{id}")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<Void> eliminar(@PathVariable("id") Long id) {
        amenidadService.eliminar(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/api/residente/amenidades")
    @PreAuthorize("hasAnyRole('ADMINISTRADOR', 'RESIDENTE')")
    public ResponseEntity<Page<AmenidadResponse>> listarResidente(
            @RequestParam("condominioId") Long condominioId,
            @PageableDefault(size = 10) Pageable pageable) {
        return ResponseEntity.ok(amenidadService.listarPorCondominio(condominioId, pageable));
    }
}
