package com.condominios.controller;

import com.condominios.dto.AlertaRequest;
import com.condominios.dto.AlertaResponse;
import com.condominios.model.GuardiaCondominio;
import com.condominios.model.User;
import com.condominios.repository.GuardiaCondominioRepository;
import com.condominios.repository.UserRepository;
import com.condominios.service.AlertaService;
import jakarta.validation.Valid;
import java.util.Map;
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
public class AlertaController {

    private final AlertaService alertaService;
    private final UserRepository userRepository;
    private final GuardiaCondominioRepository guardiaCondominioRepository;

    public AlertaController(AlertaService alertaService, UserRepository userRepository,
                            GuardiaCondominioRepository guardiaCondominioRepository) {
        this.alertaService = alertaService;
        this.userRepository = userRepository;
        this.guardiaCondominioRepository = guardiaCondominioRepository;
    }

    @PostMapping("/api/admin/alertas")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<AlertaResponse> crear(@Valid @RequestBody AlertaRequest request) {
        // ✅ Obtener el email del token JWT
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName();
        
        User admin = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));
        
        return ResponseEntity.status(HttpStatus.CREATED).body(alertaService.crear(request, admin.getId()));
    }

    @GetMapping("/api/admin/alertas")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<Page<AlertaResponse>> listarTodas(
            @PageableDefault(size = 10) Pageable pageable,
            @RequestParam(name = "condominioId", required = false) String condominioIdParam) {
        Long condominioId = condominioIdParam != null ? Long.parseLong(condominioIdParam) : null;
        return ResponseEntity.ok(alertaService.listarTodas(pageable, condominioId));
    }

    @GetMapping("/api/admin/alertas/{id}")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<AlertaResponse> obtenerPorId(@PathVariable("id") Long id) {
        return ResponseEntity.ok(alertaService.obtenerPorId(id));
    }

    @PutMapping("/api/admin/alertas/{id}")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<AlertaResponse> actualizar(@PathVariable("id") Long id,
                                                      @Valid @RequestBody AlertaRequest request) {
        return ResponseEntity.ok(alertaService.actualizar(id, request));
    }

    @DeleteMapping("/api/admin/alertas/{id}")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<Void> eliminar(@PathVariable("id") Long id) {
        alertaService.eliminar(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/api/residente/alertas")
    @PreAuthorize("hasAnyRole('ADMINISTRADOR', 'RESIDENTE')")
    public ResponseEntity<Page<AlertaResponse>> listarResidente(
            @RequestParam(name = "condominioId") Long condominioId,
            @PageableDefault(size = 10) Pageable pageable) {
        return ResponseEntity.ok(alertaService.listarActivasPorCondominio(condominioId, pageable));
    }

    @GetMapping("/api/guardia/alertas")
    @PreAuthorize("hasAnyRole('ADMINISTRADOR', 'GUARDIA')")
    public ResponseEntity<Page<AlertaResponse>> listarGuardia(
            @RequestParam(name = "condominioId") Long condominioId,
            @PageableDefault(size = 10) Pageable pageable) {
        return ResponseEntity.ok(alertaService.listarActivasPorCondominio(condominioId, pageable));
    }

    @GetMapping("/api/guardia/mi-condominio")
    @PreAuthorize("hasAnyRole('ADMINISTRADOR', 'GUARDIA')")
    public ResponseEntity<Map<String, Object>> miCondominioGuardia() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        Long condominioId = guardiaCondominioRepository.findFirstByGuardiaId(user.getId())
                .map(GuardiaCondominio::getCondominioId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "El guardia no está asignado a ningún condominio"));

        Map<String, Object> response = new java.util.HashMap<>();
        response.put("id", condominioId);
        response.put("nombre", "Condominio #" + condominioId);
        return ResponseEntity.ok(response);
    }
}