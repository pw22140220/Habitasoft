package com.condominios.controller;

import com.condominios.dto.PagoRecordatorioRequest;
import com.condominios.dto.PagoRecordatorioResponse;
import com.condominios.model.User;
import com.condominios.repository.AdminCondominioRepository;
import com.condominios.repository.UserRepository;
import com.condominios.service.PagoService;
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

import java.util.List;

@RestController
@CrossOrigin(origins = "*")
public class PagoController {

    private final PagoService pagoService;
    private final UserRepository userRepository;
    private final AdminCondominioRepository adminCondominioRepository;

    public PagoController(PagoService pagoService,
                          UserRepository userRepository,
                          AdminCondominioRepository adminCondominioRepository) {
        this.pagoService = pagoService;
        this.userRepository = userRepository;
        this.adminCondominioRepository = adminCondominioRepository;
    }

    private User getAuthenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName();
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Usuario no encontrado"));
    }

    private Long getAdminCondominioId(User admin, Long condominioId) {
        if (condominioId != null) {
            boolean asignado = adminCondominioRepository
                    .findByAdminIdOrderByFechaAsignacionAsc(admin.getId())
                    .stream()
                    .anyMatch(ac -> ac.getId().getCondominioId().equals(condominioId));
            if (!asignado) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                        "No tienes acceso a este condominio");
            }
            return condominioId;
        }
        List<com.condominios.model.AdminCondominio> asignaciones =
                adminCondominioRepository.findByAdminIdOrderByFechaAsignacionAsc(admin.getId());
        if (asignaciones.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "El administrador no tiene condominios asignados");
        }
        return asignaciones.get(0).getId().getCondominioId();
    }

    // ==================== ADMIN ====================

    @PostMapping("/api/admin/pagos/recordatorio")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<PagoRecordatorioResponse> crearRecordatorio(
            @Valid @RequestBody PagoRecordatorioRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(pagoService.crearRecordatorio(request));
    }

    @GetMapping("/api/admin/pagos")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<Page<PagoRecordatorioResponse>> listarTodos(
            @PageableDefault(size = 10) Pageable pageable,
            @RequestParam(name = "estado", required = false) String estado,
            @RequestParam(name = "condominioId", required = false) Long condominioId) {
        User admin = getAuthenticatedUser();
        Long cid = getAdminCondominioId(admin, condominioId);
        return ResponseEntity.ok(pagoService.listarPorCondominio(cid, estado, pageable));
    }

    @GetMapping("/api/admin/pagos/residentes/{residenteId}")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<Page<PagoRecordatorioResponse>> listarPorResidente(
            @PathVariable("residenteId") Long residenteId,
            @PageableDefault(size = 10) Pageable pageable,
            @RequestParam(name = "condominioId", required = false) Long condominioId) {
        User admin = getAuthenticatedUser();
        Long cid = getAdminCondominioId(admin, condominioId);
        return ResponseEntity.ok(pagoService.listarPorResidente(residenteId, cid, pageable));
    }

    @PutMapping("/api/admin/pagos/{id}/registrar-pago")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<PagoRecordatorioResponse> registrarPagoManual(
            @PathVariable("id") Long id,
            @RequestParam(name = "metodoPago", defaultValue = "efectivo") String metodoPago) {
        return ResponseEntity.ok(pagoService.registrarPagoManual(id, metodoPago));
    }

    @DeleteMapping("/api/admin/pagos/{id}")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ResponseEntity<Void> eliminar(@PathVariable("id") Long id) {
        pagoService.eliminar(id);
        return ResponseEntity.noContent().build();
    }

    // ==================== RESIDENTE ====================

    @GetMapping("/api/residente/pagos")
    @PreAuthorize("hasAnyRole('ADMINISTRADOR', 'RESIDENTE')")
    public ResponseEntity<Page<PagoRecordatorioResponse>> listarMisPagos(
            @PageableDefault(size = 10) Pageable pageable) {
        User residente = getAuthenticatedUser();
        return ResponseEntity.ok(pagoService.listarMisPagos(residente.getId(), pageable));
    }

    @PutMapping("/api/residente/pagos/{id}/pagar")
    @PreAuthorize("hasAnyRole('ADMINISTRADOR', 'RESIDENTE')")
    public ResponseEntity<PagoRecordatorioResponse> marcarComoPagado(
            @PathVariable("id") Long id,
            @RequestParam(name = "metodoPago", defaultValue = "transferencia") String metodoPago) {
        User residente = getAuthenticatedUser();
        return ResponseEntity.ok(pagoService.marcarComoPagado(id, residente.getId(), metodoPago));
    }
}
