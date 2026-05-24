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
            .csrf(csrf -> csrf.disable())

            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )

            .authorizeHttpRequests(auth -> auth

                .requestMatchers("/api/auth/login").permitAll()

                .requestMatchers(
                    "/api/admin/**",
                    "/api/usuarios/**"
                ).hasRole("ADMINISTRADOR")

                .requestMatchers(
                    "/api/pagos/**",
                    "/api/notificaciones/**",
                    "/api/reservaciones/**",
                    "/api/amenidades/**",
                    "/api/incidentes/**",
                    "/api/pases-visita/**",
                    "/api/residente/alertas/**"
                ).hasAnyRole("ADMINISTRADOR", "RESIDENTE")

                .requestMatchers(
                    "/api/guardia/alertas/**"
                ).hasAnyRole("ADMINISTRADOR", "GUARDIA")

                .anyRequest().authenticated()
            )

            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
