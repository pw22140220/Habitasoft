package com.condominios.config;

import com.condominios.security.JwtAuthenticationFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

/**
 * Configuración de seguridad Spring.
 *
 * Define qué rutas son públicas, cuáles requieren autenticación,
 * y qué roles pueden acceder a cada endpoint.
 *
 * Los roles en la BD son: administrador, residente, guardia.
 * Spring Security internamente usa el prefijo ROLE_, por lo que
 * las reglas usan hasRole("ADMINISTRADOR"), hasRole("RESIDENTE"), etc.
 *
 * @see com.condominios.security.JwtAuthenticationFilter
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http,
                                           JwtAuthenticationFilter jwtAuthFilter) throws Exception {
        http
            // Deshabilitar CSRF porque usamos JWT (stateless)
            .csrf(csrf -> csrf.disable())

            // Sesión sin estado (cada request lleva su token)
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )

            .authorizeHttpRequests(auth -> auth

                /*
                 * =============================================
                 * RUTAS PÚBLICAS (no requieren token)
                 * =============================================
                 */
                .requestMatchers("/api/auth/login").permitAll()

                /*
                 * =============================================
                 * RUTAS SOLO PARA ADMINISTRADOR
                 * =============================================
                 */
                .requestMatchers(
                    "/api/admin/**",
                    "/api/usuarios/**"
                ).hasRole("ADMINISTRADOR")

                /*
                 * =============================================
                 * RUTAS PARA ADMINISTRADOR Y RESIDENTE
                 * =============================================
                 */
                .requestMatchers(
                    "/api/condominios/**",
                    "/api/pagos/**",
                    "/api/notificaciones/**",
                    "/api/reservaciones/**",
                    "/api/amenidades/**",
                    "/api/incidentes/**"
                ).hasAnyRole("ADMINISTRADOR", "RESIDENTE")

                /*
                 * =============================================
                 * RUTAS PARA GUARDIA
                 * =============================================
                 */
                .requestMatchers(
                    "/api/pases-visita/**",
                    "/api/incidentes/**"
                ).hasAnyRole("GUARDIA", "ADMINISTRADOR")

                /*
                 * =============================================
                 * CUALQUIER OTRA RUTA requiere autenticación
                 * (sin importar el rol)
                 * =============================================
                 */
                .anyRequest().authenticated()
            )

            // Registrar el filtro JWT antes del filtro de autenticación de Spring
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
