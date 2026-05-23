package com.condominios.service;

import com.condominios.dto.LoginRequest;
import com.condominios.dto.LoginResponse;
import com.condominios.dto.UserDto;
import com.condominios.model.User;
import com.condominios.repository.UserRepository;
import com.condominios.security.JwtService;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

/**
 * Servicio de autenticación.
 *
 * Valida las credenciales contra la tabla Usuarios.
 * La tabla usa la columna "password_hash" para almacenar
 * el hash BCrypt de la contraseña.
 */
@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthService(UserRepository userRepository,
                       PasswordEncoder passwordEncoder,
                       JwtService jwtService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    /**
     * Intenta autenticar un usuario con email y contraseña.
     *
     * @param request DTO con email y password en texto plano.
     * @return LoginResponse con tokens JWT y datos del usuario.
     * @throws ResponseStatusException 401 si las credenciales son inválidas.
     */
    public LoginResponse login(LoginRequest request) {

        // Buscar usuario por email
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED, "Credenciales inválidas"));

        // Validar contraseña contra el hash almacenado
        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new ResponseStatusException(
                    HttpStatus.UNAUTHORIZED, "Credenciales inválidas");
        }

        // Generar tokens JWT
        String accessToken = jwtService.generateAccessToken(user);
        String refreshToken = jwtService.generateRefreshToken(user);

        // Construir DTO de respuesta (sin password_hash)
        UserDto userDto = new UserDto();
        userDto.setId(user.getId());
        userDto.setNombre(user.getNombre());
        userDto.setEmail(user.getEmail());
        userDto.setTelefono(user.getTelefono());
        userDto.setRol(user.getRol());

        LoginResponse response = new LoginResponse();
        response.setAccessToken(accessToken);
        response.setRefreshToken(refreshToken);
        response.setUsuario(userDto);

        return response;
    }
}
