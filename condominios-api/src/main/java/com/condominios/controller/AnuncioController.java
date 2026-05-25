package com.condominios.controller;

import com.condominios.dto.AnuncioRequest;
import com.condominios.dto.AnuncioResponse;
import com.condominios.model.User;
import com.condominios.repository.UserRepository;
import com.condominios.service.AnuncioService;
import com.condominios.service.UsuarioService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@RestController
@CrossOrigin(origins = "*")
public class AnuncioController {

    private final AnuncioService anuncioService;
    private final UsuarioService usuarioService;

    public AnuncioController(AnuncioService anuncioService, UsuarioService usuarioService) {
        this.anuncioService = anuncioService;
        this.usuarioService = usuarioService;
    }

    // ==================== ADMIN ====================

    @PostMapping("/api/admin/anuncios")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<AnuncioResponse> crear(@Valid @RequestBody AnuncioRequest request,
                                                  @RequestParam("condominioId") Long condominioId,
                                                  Principal principal) {
        User admin = usuarioService.obtenerUsuarioPorEmail(principal.getName());
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(anuncioService.crear(request, admin.getId(), condominioId));
    }

    @GetMapping("/api/admin/anuncios")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<Page<AnuncioResponse>> listar(
            @PageableDefault(size = 10) Pageable pageable,
            @RequestParam("condominioId") Long condominioId) {
        return ResponseEntity.ok(anuncioService.listarPorCondominio(condominioId, pageable));
    }

    @GetMapping("/api/admin/anuncios/{id}")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<AnuncioResponse> obtenerPorId(@PathVariable("id") Long id) {
        return ResponseEntity.ok(anuncioService.obtenerPorId(id));
    }

    @PutMapping("/api/admin/anuncios/{id}")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<AnuncioResponse> actualizar(@PathVariable("id") Long id,
                                                       @Valid @RequestBody AnuncioRequest request) {
        return ResponseEntity.ok(anuncioService.actualizar(id, request));
    }

    @DeleteMapping("/api/admin/anuncios/{id}")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<Void> eliminar(@PathVariable("id") Long id) {
        anuncioService.eliminar(id);
        return ResponseEntity.noContent().build();
    }

    // ==================== RESIDENTE ====================

    @GetMapping("/api/residente/anuncios")
    @PreAuthorize("hasAnyRole('ADMINISTRADOR', 'RESIDENTE')")
    public ResponseEntity<Page<AnuncioResponse>> listarResidente(
            @RequestParam("condominioId") Long condominioId,
            @PageableDefault(size = 10) Pageable pageable) {
        return ResponseEntity.ok(
                anuncioService.listarActivosParaResidentes(condominioId, pageable));
    }
}
