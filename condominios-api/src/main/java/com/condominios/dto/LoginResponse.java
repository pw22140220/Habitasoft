package com.condominios.dto;

import java.util.List;
import java.util.Map;

public class LoginResponse {

    private String accessToken;
    private String refreshToken;
    private UsuarioDto usuario;
    private List<Map<String, Object>> rolesPorCondominio;
    private List<Map<String, Object>> rolesPorUnidad;
    private String userRole;
    
    public String getUserRole() { return userRole; }
    public void setUserRole(String userRole) { this.userRole = userRole; }

    public String getAccessToken() { return accessToken; }
    public void setAccessToken(String accessToken) { this.accessToken = accessToken; }

    public String getRefreshToken() { return refreshToken; }
    public void setRefreshToken(String refreshToken) { this.refreshToken = refreshToken; }

    public UsuarioDto getUsuario() { return usuario; }
    public void setUsuario(UsuarioDto usuario) { this.usuario = usuario; }

    public List<Map<String, Object>> getRolesPorCondominio() { return rolesPorCondominio; }
    public void setRolesPorCondominio(List<Map<String, Object>> rolesPorCondominio) { this.rolesPorCondominio = rolesPorCondominio; }

    public List<Map<String, Object>> getRolesPorUnidad() { return rolesPorUnidad; }
    public void setRolesPorUnidad(List<Map<String, Object>> rolesPorUnidad) { this.rolesPorUnidad = rolesPorUnidad; }
}