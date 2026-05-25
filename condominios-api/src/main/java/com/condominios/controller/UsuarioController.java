package com.condominios.controller;

import com.condominios.dto.UsuarioRequest;
import com.condominios.dto.UsuarioResponse;
import com.condominios.model.User;
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
@RequestMapping("/api/admin/usuarios")
@CrossOrigin(origins = "*")
@PreAuthorize("hasRole('administrador')")
public class UsuarioController {

    private final UsuarioService usuarioService;

    public UsuarioController(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    @PostMapping
    public ResponseEntity<UsuarioResponse> crear(@Valid @RequestBody UsuarioRequest request,
                                                  @RequestParam("condominioId") Long condominioId,
                                                  Principal principal) {
        User admin = usuarioService.obtenerUsuarioPorEmail(principal.getName());
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(usuarioService.crear(request, admin.getId(), condominioId));
    }

    @GetMapping
    public ResponseEntity<Page<UsuarioResponse>> listar(@PageableDefault(size = 10) Pageable pageable,
                                                         @RequestParam(value = "search", required = false) String search,
                                                         @RequestParam("condominioId") Long condominioId) {
        return ResponseEntity.ok(
                usuarioService.listarPorCondominio(condominioId, pageable, search));
    }

    @GetMapping("/{id}")
    public ResponseEntity<UsuarioResponse> obtenerPorId(@PathVariable("id") Long id) {
        return ResponseEntity.ok(usuarioService.obtenerPorId(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<UsuarioResponse> actualizar(@PathVariable("id") Long id,
                                                       @Valid @RequestBody UsuarioRequest request,
                                                       @RequestParam("condominioId") Long condominioId) {
        return ResponseEntity.ok(usuarioService.actualizar(id, request, condominioId));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable("id") Long id) {
        usuarioService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}
