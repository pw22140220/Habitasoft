package com.condominios.service;

import com.condominios.dto.LoginRequest;
import com.condominios.dto.LoginResponse;
import com.condominios.dto.UsuarioDto;
import com.condominios.model.Usuario;
import com.condominios.model.UsuarioAuth;
import com.condominios.repository.UsuarioAuthRepository;
import com.condominios.repository.UsuarioRepository;
import com.condominios.security.JwtService;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.Collections;

@Service
public class AuthService {

    private final UsuarioRepository usuarioRepository;
    private final UsuarioAuthRepository usuarioAuthRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthService(UsuarioRepository usuarioRepository,
                       UsuarioAuthRepository usuarioAuthRepository,
                       PasswordEncoder passwordEncoder,
                       JwtService jwtService) {
        this.usuarioRepository = usuarioRepository;
        this.usuarioAuthRepository = usuarioAuthRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    public LoginResponse login(LoginRequest request) {

        Usuario usuario = usuarioRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Credenciales inválidas"));

        if (!usuario.isActivo()) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Usuario inactivo");
        }

        UsuarioAuth auth = usuarioAuthRepository.findById(usuario.getUsuarioId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Credenciales inválidas"));

        if (!passwordEncoder.matches(request.getPassword(), auth.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Credenciales inválidas");
        }

        String accessToken = jwtService.generateAccessToken(usuario);
        String refreshToken = jwtService.generateRefreshToken(usuario);

        UsuarioDto usuarioDto = new UsuarioDto();
        usuarioDto.setUsuarioId(usuario.getUsuarioId());
        usuarioDto.setNombre(usuario.getNombre());
        usuarioDto.setEmail(usuario.getEmail());
        usuarioDto.setTelefono(usuario.getTelefono());
        usuarioDto.setActivo(usuario.isActivo());

        LoginResponse response = new LoginResponse();
        response.setAccessToken(accessToken);
        response.setRefreshToken(refreshToken);
        response.setUsuario(usuarioDto);
        response.setRolesPorCondominio(Collections.emptyList());
        response.setRolesPorUnidad(Collections.emptyList());

        return response;
    }
}