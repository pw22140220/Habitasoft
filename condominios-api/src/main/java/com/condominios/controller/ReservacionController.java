package com.condominios.controller;

import com.condominios.dto.ReservacionRequest;
import com.condominios.dto.ReservacionResponse;
import com.condominios.model.User;
import com.condominios.repository.UserRepository;
import com.condominios.service.ReservacionService;
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
public class ReservacionController {

    private final ReservacionService reservacionService;
    private final UserRepository userRepository;

    public ReservacionController(ReservacionService reservacionService,
                                  UserRepository userRepository) {
        this.reservacionService = reservacionService;
        this.userRepository = userRepository;
    }

    private User getAuthenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName();
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Usuario no encontrado"));
    }

    @PostMapping("/api/residente/reservaciones")
    @PreAuthorize("hasAnyRole('ADMINISTRADOR', 'RESIDENTE')")
    public ResponseEntity<ReservacionResponse> crear(
            @Valid @RequestBody ReservacionRequest request) {
        User residente = getAuthenticatedUser();
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(reservacionService.crear(request, residente.getId()));
    }

    @GetMapping("/api/residente/reservaciones")
    @PreAuthorize("hasAnyRole('ADMINISTRADOR', 'RESIDENTE')")
    public ResponseEntity<Page<ReservacionResponse>> listarMisReservaciones(
            @PageableDefault(size = 10) Pageable pageable) {
        User residente = getAuthenticatedUser();
        return ResponseEntity.ok(
                reservacionService.listarMisReservaciones(residente.getId(), pageable));
    }

    @DeleteMapping("/api/residente/reservaciones/{id}")
    @PreAuthorize("hasAnyRole('ADMINISTRADOR', 'RESIDENTE')")
    public ResponseEntity<Void> cancelar(@PathVariable("id") Long id) {
        User residente = getAuthenticatedUser();
        reservacionService.cancelar(id, residente.getId());
        return ResponseEntity.noContent().build();
    }
}
