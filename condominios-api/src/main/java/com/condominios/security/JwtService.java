package com.condominios.security;

import com.condominios.model.User;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Servicio para generar y validar tokens JWT.
 * Utiliza la librería jjwt (io.jsonwebtoken).
 */
@Service
public class JwtService {

    private final Key signingKey;
    private final long accessTokenExpirationMs;
    private final long refreshTokenExpirationMs;

    public JwtService(
            @Value("${jwt.secret}") String secret,
            @Value("${jwt.access-token-expiration-ms}") long accessTokenExpirationMs,
            @Value("${jwt.refresh-token-expiration-ms}") long refreshTokenExpirationMs
    ) {
        this.signingKey = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
        this.accessTokenExpirationMs = accessTokenExpirationMs;
        this.refreshTokenExpirationMs = refreshTokenExpirationMs;
    }

    /**
     * Genera un access token JWT con los datos del usuario.
     */
    public String generateAccessToken(User user) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("email", user.getEmail());
        claims.put("nombre", user.getNombre());
        claims.put("rol", user.getRol().name());

        long now = System.currentTimeMillis();

        return Jwts.builder()
                .setClaims(claims)
                .setSubject(String.valueOf(user.getId()))
                .setIssuedAt(new Date(now))
                .setExpiration(new Date(now + accessTokenExpirationMs))
                .signWith(signingKey, SignatureAlgorithm.HS256)
                .compact();
    }

    /**
     * Genera un refresh token JWT (vida más larga, sin claims adicionales).
     */
    public String generateRefreshToken(User user) {
        long now = System.currentTimeMillis();

        return Jwts.builder()
                .setSubject(String.valueOf(user.getId()))
                .setIssuedAt(new Date(now))
                .setExpiration(new Date(now + refreshTokenExpirationMs))
                .claim("type", "refresh")
                .signWith(signingKey, SignatureAlgorithm.HS256)
                .compact();
    }
}
