package com.condominios.dto;

/**
 * Respuesta estándar del endpoint de login.
 * Incluye los tokens JWT y los datos públicos del usuario autenticado.
 */
public class LoginResponse {

    private String accessToken;
    private String refreshToken;
    private UserDto usuario;

    // ====== GETTERS Y SETTERS ======

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public String getRefreshToken() {
        return refreshToken;
    }

    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }

    public UserDto getUsuario() {
        return usuario;
    }

    public void setUsuario(UserDto usuario) {
        this.usuario = usuario;
    }
}
