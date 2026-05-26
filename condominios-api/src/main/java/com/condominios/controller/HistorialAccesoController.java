package com.condominios.controller;

import com.condominios.dto.HistorialAccesoResponse;
import com.condominios.model.User;
import com.condominios.repository.UserRepository;
import com.condominios.service.HistorialAccesoService;
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

import java.util.Map;

@RestController
@CrossOrigin(origins = "*")
public class HistorialAccesoController {

    private final HistorialAccesoService historialAccesoService;
    private final UserRepository userRepository;

    public HistorialAccesoController(HistorialAccesoService historialAccesoService,
                                      UserRepository userRepository) {
        this.historialAccesoService = historialAccesoService;
        this.userRepository = userRepository;
    }

    private User getAuthenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName();
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Usuario no encontrado"));
    }

    @GetMapping("/api/guardia/historial")
    @PreAuthorize("hasRole('GUARDIA')")
    public ResponseEntity<Page<HistorialAccesoResponse>> listarHistorialGuardia(
            @PageableDefault(size = 20) Pageable pageable) {
        User guardia = getAuthenticatedUser();
        return ResponseEntity.ok(
                historialAccesoService.listarPorGuardia(guardia.getId(), pageable));
    }

    @GetMapping("/api/guardia/historial/stats")
    @PreAuthorize("hasRole('GUARDIA')")
    public ResponseEntity<Map<String, Object>> obtenerEstadisticasGuardia() {
        User guardia = getAuthenticatedUser();
        return ResponseEntity.ok(
                historialAccesoService.obtenerEstadisticasGuardia(guardia.getId()));
    }

    @GetMapping("/api/admin/historial")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<Page<HistorialAccesoResponse>> listarHistorialAdmin(
            @RequestParam("condominioId") Long condominioId,
            @PageableDefault(size = 20) Pageable pageable) {
        return ResponseEntity.ok(
                historialAccesoService.listarPorAdmin(condominioId, pageable));
    }

    @GetMapping("/api/admin/historial/stats")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<Map<String, Object>> obtenerEstadisticasAdmin(
            @RequestParam("condominioId") Long condominioId) {
        return ResponseEntity.ok(
                historialAccesoService.obtenerEstadisticasAdmin(condominioId));
    }
}
