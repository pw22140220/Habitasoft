package com.condominios.controller;

import com.condominios.dto.PaseDeVisitaRequest;
import com.condominios.dto.PaseDeVisitaResponse;
import com.condominios.dto.ValidarQrRequest;
import com.condominios.dto.ValidarQrResponse;
import com.condominios.model.User;
import com.condominios.repository.UserRepository;
import com.condominios.service.PaseDeVisitaService;
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
public class PaseDeVisitaController {

    private final PaseDeVisitaService paseDeVisitaService;
    private final UserRepository userRepository;

    public PaseDeVisitaController(PaseDeVisitaService paseDeVisitaService,
                                   UserRepository userRepository) {
        this.paseDeVisitaService = paseDeVisitaService;
        this.userRepository = userRepository;
    }

    private User getAuthenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName();
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Usuario no encontrado"));
    }

    @PostMapping("/api/residente/pases-visita")
    @PreAuthorize("hasAnyRole('ADMINISTRADOR', 'RESIDENTE')")
    public ResponseEntity<PaseDeVisitaResponse> generar(
            @Valid @RequestBody PaseDeVisitaRequest request) {
        User residente = getAuthenticatedUser();
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(paseDeVisitaService.generar(request, residente.getId()));
    }

    @GetMapping("/api/residente/mis-pases")
    @PreAuthorize("hasAnyRole('ADMINISTRADOR', 'RESIDENTE')")
    public ResponseEntity<Page<PaseDeVisitaResponse>> listarMisPases(
            @PageableDefault(size = 10) Pageable pageable) {
        User residente = getAuthenticatedUser();
        return ResponseEntity.ok(
                paseDeVisitaService.listarMisPases(residente.getId(), pageable));
    }

    @PostMapping("/api/guardia/validar-qr")
    @PreAuthorize("hasAnyRole('GUARDIA', 'ADMINISTRADOR')")
    public ResponseEntity<ValidarQrResponse> validarQr(
            @Valid @RequestBody ValidarQrRequest request) {
        User guardia = getAuthenticatedUser();
        return ResponseEntity.ok(
                paseDeVisitaService.validarQr(request, guardia.getId()));
    }
}
