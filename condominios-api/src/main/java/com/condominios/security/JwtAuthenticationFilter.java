package com.condominios.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Collections;
import java.util.List;

/**
 * Filtro que intercepta cada petición HTTP, extrae el token JWT del header
 * Authorization, lo valida y establece la autenticación en el contexto de
 * Spring Security.
 *
 * Las rutas públicas (como /api/auth/login) se saltan automáticamente
 * para permitir el inicio de sesión sin token.
 *
 * El rol se obtiene del claim "rol" del JWT y se mapea al formato
 * "ROLE_ADMINISTRADOR", "ROLE_RESIDENTE", "ROLE_GUARDIA" que Spring Security
 * espera para las reglas de autorización.
 */
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final Key signingKey;

    public JwtAuthenticationFilter(@Value("${jwt.secret}") String secret) {
        this.signingKey = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        /*
         * Rutas públicas que NO deben pasar por el filtro JWT.
         * El login debe funcionar sin token.
         */
        String path = request.getRequestURI();
        return path.equals("/api/auth/login");
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        // Extraer el header Authorization
        final String authHeader = request.getHeader("Authorization");

        // Si no hay token, continuar sin autenticar
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        // Remover el prefijo "Bearer " para quedarnos solo con el token
        final String token = authHeader.substring(7);

        try {
            // Parsear el JWT y extraer los claims
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(signingKey)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();

            // Obtener datos del token
            String email = claims.get("email", String.class);
            String rol = claims.get("rol", String.class);

            /*
             * Mapear el rol de la BD (minúsculas, español) al formato
             * que Spring Security espera: ROLE_ + MAYÚSCULAS.
             *
             * BD: "administrador" → Spring: "ROLE_ADMINISTRADOR"
             * BD: "residente"    → Spring: "ROLE_RESIDENTE"
             * BD: "guardia"      → Spring: "ROLE_GUARDIA"
             */
            String roleName = "ROLE_" + rol.toUpperCase();

            List<GrantedAuthority> authorities = Collections.singletonList(
                new SimpleGrantedAuthority(roleName)
            );

            // Crear token de autenticación y establecerlo en el contexto de seguridad
            UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken(email, null, authorities);

            SecurityContextHolder.getContext().setAuthentication(authentication);

        } catch (Exception e) {
            // Token inválido o expirado: limpiar la autenticación
            SecurityContextHolder.clearContext();
        }

        // Continuar con la cadena de filtros
        filterChain.doFilter(request, response);
    }
}
