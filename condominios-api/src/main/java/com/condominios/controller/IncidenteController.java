package com.condominios.controller;

import com.condominios.dto.IncidenteRequest;
import com.condominios.dto.IncidenteResponse;
import com.condominios.model.GuardiaCondominio;
import com.condominios.model.Incidente.Estado;
import com.condominios.model.User;
import com.condominios.repository.GuardiaCondominioRepository;
import com.condominios.repository.UserRepository;
import com.condominios.service.IncidenteService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@CrossOrigin(origins = "*")
public class IncidenteController {

    private final IncidenteService incidenteService;
    private final UserRepository userRepository;
    private final GuardiaCondominioRepository guardiaCondominioRepository;

    public IncidenteController(IncidenteService incidenteService,
                                UserRepository userRepository,
                                GuardiaCondominioRepository guardiaCondominioRepository) {
        this.incidenteService = incidenteService;
        this.userRepository = userRepository;
        this.guardiaCondominioRepository = guardiaCondominioRepository;
    }

    private User obtenerUsuarioAutenticado() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName();
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));
    }

    @PostMapping("/api/incidentes")
    @PreAuthorize("hasRole('GUARDIA')")
    public ResponseEntity<IncidenteResponse> crear(@Valid @RequestBody IncidenteRequest request) {
        User guardia = obtenerUsuarioAutenticado();
        Long condominioId = request.getCondominioId();
        if (condominioId == null) {
            condominioId = guardiaCondominioRepository.findFirstByGuardiaId(guardia.getId())
                    .map(GuardiaCondominio::getCondominioId)
                    .orElse(null);
        }
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(incidenteService.crear(request, guardia.getId(), condominioId));
    }

    @GetMapping("/api/incidentes/mis-incidentes")
    @PreAuthorize("hasRole('GUARDIA')")
    public ResponseEntity<Page<IncidenteResponse>> listarMisIncidentes(
            @PageableDefault(size = 20) Pageable pageable) {
        User guardia = obtenerUsuarioAutenticado();
        return ResponseEntity.ok(incidenteService.listarPorGuardia(guardia.getId(), pageable));
    }

    @GetMapping("/api/incidentes/{id}")
    @PreAuthorize("hasAnyRole('ADMINISTRADOR', 'GUARDIA')")
    public ResponseEntity<IncidenteResponse> obtenerPorId(@PathVariable("id") Long id) {
        return ResponseEntity.ok(incidenteService.obtenerPorId(id));
    }

    @PutMapping("/api/incidentes/{id}")
    @PreAuthorize("hasRole('GUARDIA')")
    public ResponseEntity<IncidenteResponse> actualizar(
            @PathVariable("id") Long id,
            @Valid @RequestBody IncidenteRequest request) {
        User guardia = obtenerUsuarioAutenticado();
        return ResponseEntity.ok(incidenteService.actualizar(id, request, guardia.getId()));
    }

    @PatchMapping("/api/incidentes/{id}/estado")
    @PreAuthorize("hasRole('GUARDIA')")
    public ResponseEntity<IncidenteResponse> actualizarEstado(
            @PathVariable("id") Long id,
            @RequestParam("estado") String estadoParam) {
        User guardia = obtenerUsuarioAutenticado();
        Estado estado;
        try {
            estado = Estado.valueOf(estadoParam);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Estado inválido. Valores: nuevo, en_progreso, resuelto");
        }
        return ResponseEntity.ok(incidenteService.actualizarEstado(id, estado, guardia.getId()));
    }

    @DeleteMapping("/api/incidentes/{id}")
    @PreAuthorize("hasAnyRole('ADMINISTRADOR', 'GUARDIA')")
    public ResponseEntity<Void> eliminar(@PathVariable("id") Long id) {
        User usuario = obtenerUsuarioAutenticado();
        incidenteService.eliminar(id, usuario.getId(), usuario.getRol().name());
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/api/admin/incidentes")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<Page<IncidenteResponse>> listarTodos(
            @RequestParam(name = "condominioId", required = false) Long condominioId,
            @PageableDefault(size = 20) Pageable pageable) {
        return ResponseEntity.ok(incidenteService.listarTodos(pageable, condominioId));
    }
}
