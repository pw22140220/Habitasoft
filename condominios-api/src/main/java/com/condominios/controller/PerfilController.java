package com.condominios.controller;

import com.condominios.dto.CambioPasswordRequest;
import com.condominios.dto.UsuarioPerfilRequest;
import com.condominios.dto.UsuarioPerfilResponse;
import com.condominios.model.User;
import com.condominios.repository.UserRepository;
import com.condominios.service.UsuarioService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@CrossOrigin(origins = "*")
public class PerfilController {

    private final UsuarioService usuarioService;
    private final UserRepository userRepository;

    public PerfilController(UsuarioService usuarioService, UserRepository userRepository) {
        this.usuarioService = usuarioService;
        this.userRepository = userRepository;
    }

    private User getAuthenticatedUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Usuario no encontrado"));
    }

    @GetMapping("/api/usuario/perfil")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<UsuarioPerfilResponse> obtenerPerfil() {
        User user = getAuthenticatedUser();
        return ResponseEntity.ok(usuarioService.obtenerPerfil(user.getId()));
    }

    @PutMapping("/api/usuario/perfil")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<UsuarioPerfilResponse> actualizarPerfil(
            @Valid @RequestBody UsuarioPerfilRequest request) {
        User user = getAuthenticatedUser();
        return ResponseEntity.ok(
                usuarioService.actualizarPerfil(
                        user.getId(), request.getNombre(), request.getEmail(), request.getTelefono()));
    }

    @PutMapping("/api/usuario/cambiar-password")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> cambiarPassword(
            @Valid @RequestBody CambioPasswordRequest request) {
        User user = getAuthenticatedUser();
        usuarioService.cambiarPassword(user.getId(), request);
        return ResponseEntity.ok().build();
    }
}
