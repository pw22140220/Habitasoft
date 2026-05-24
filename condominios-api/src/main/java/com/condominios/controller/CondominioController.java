package com.condominios.controller;

import com.condominios.dto.CondominioRequest;
import com.condominios.dto.CondominioResponse;
import com.condominios.service.CondominioService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin/condominios")
@CrossOrigin(origins = "*")
@PreAuthorize("hasRole('ADMINISTRADOR')")
public class CondominioController {

    private final CondominioService condominioService;

    public CondominioController(CondominioService condominioService) {
        this.condominioService = condominioService;
    }

    @PostMapping
    public ResponseEntity<CondominioResponse> crear(@Valid @RequestBody CondominioRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(condominioService.crear(request));
    }

    @GetMapping
    public ResponseEntity<Page<CondominioResponse>> listar(@PageableDefault(size = 10) Pageable pageable) {
        return ResponseEntity.ok(condominioService.listar(pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<CondominioResponse> obtenerPorId(@PathVariable("id") Long id) {
        return ResponseEntity.ok(condominioService.obtenerPorId(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<CondominioResponse> actualizar(@PathVariable("id") Long id,
                                                          @Valid @RequestBody CondominioRequest request) {
        return ResponseEntity.ok(condominioService.actualizar(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable("id") Long id) {
        condominioService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}