package com.condominios.controller;

import com.condominios.dto.LoginRequest;
import com.condominios.dto.LoginResponse;
import com.condominios.service.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    // ✅ Login - PRODUCCIÓN
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    // ✅ Perfil del usuario - PRODUCCIÓN
    @GetMapping("/perfil")
    public ResponseEntity<Map<String, Object>> getPerfil(Authentication authentication) {
        Map<String, Object> perfil = new HashMap<>();
        perfil.put("email", authentication.getName());
        perfil.put("rol", authentication.getAuthorities().stream()
            .map(GrantedAuthority::getAuthority)
            .map(rol -> rol.replace("ROLE_", "")) // Quita el prefijo ROLE_
            .collect(Collectors.toList()));
        return ResponseEntity.ok(perfil);
    }

    // ========== TUS ENDPOINTS REALES DE NEGOCIO ==========
    
    // ✅ Dashboard Admin - PRODUCCIÓN
    @GetMapping("/admin/dashboard")
    public ResponseEntity<Map<String, Object>> adminDashboard() {
        Map<String, Object> dashboard = new HashMap<>();
        dashboard.put("totalUsuarios", 150);
        dashboard.put("totalPagos", 50000);
        return ResponseEntity.ok(dashboard);
    }

    // ✅ Dashboard Residente - PRODUCCIÓN
    @GetMapping("/residente/mis-pagos")
    public ResponseEntity<Map<String, Object>> residentePagos(Authentication authentication) {
        Map<String, Object> pagos = new HashMap<>();
        pagos.put("email", authentication.getName());
        pagos.put("pendientes", "Cuota marzo: $2,500");
        return ResponseEntity.ok(pagos);
    }
 // Endpoint público para probar que el login funciona
    @GetMapping("/public/test")
    public ResponseEntity<String> publicTest() {
        return ResponseEntity.ok("El servidor funciona correctamente");
    }

    // Endpoint que CUALQUIER usuario autenticado puede ver
    @GetMapping("/user/me")
    public ResponseEntity<Map<String, Object>> getUserInfo(Authentication auth) {
        Map<String, Object> info = new HashMap<>();
        info.put("email", auth.getName());
        info.put("roles", auth.getAuthorities());
        info.put("mensaje", "Estás autenticado correctamente");
        return ResponseEntity.ok(info);
    }
}