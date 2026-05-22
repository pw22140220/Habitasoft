package com.condominios;

import com.condominios.model.Usuario;
import com.condominios.model.UsuarioAuth;
import com.condominios.repository.UsuarioAuthRepository;
import com.condominios.repository.UsuarioRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.password.PasswordEncoder;

@SpringBootApplication
public class CondominiosApplication {

    public static void main(String[] args) {
        SpringApplication.run(CondominiosApplication.class, args);
    }

    @Bean
    public CommandLineRunner initData(UsuarioRepository usuarioRepository,
                                      UsuarioAuthRepository usuarioAuthRepository,
                                      PasswordEncoder passwordEncoder) {
        return args -> {

            crearUsuarioSiNoExiste(
                "Admin General",
                "admin@demo.com",
                "5555555555",
                "123456",
                usuarioRepository,
                usuarioAuthRepository,
                passwordEncoder
            );

            crearUsuarioSiNoExiste(
                "Juan Pérez",
                "juan@demo.com",
                "5551112222",
                "MiClave123",
                usuarioRepository,
                usuarioAuthRepository,
                passwordEncoder
            );

            crearUsuarioSiNoExiste(
                    "Carlos ",
                    "admin@habitasoft.com",
                    "5551112222",
                    "admin123",
                    usuarioRepository,
                    usuarioAuthRepository,
                    passwordEncoder
             );
        };
    }

    private void crearUsuarioSiNoExiste(String nombre,
                                        String email,
                                        String telefono,
                                        String rawPassword,
                                        UsuarioRepository usuarioRepository,
                                        UsuarioAuthRepository usuarioAuthRepository,
                                        PasswordEncoder passwordEncoder) {

        // ¿Ya existe un usuario con ese email?
        if (usuarioRepository.findByEmail(email).isPresent()) {
            System.out.println("Usuario ya existe, no se crea de nuevo: " + email);
            return;
        }

        // 1) Crear el Usuario
        Usuario usuario = new Usuario();
        usuario.setNombre(nombre);
        usuario.setEmail(email);
        usuario.setTelefono(telefono);
        usuario.setActivo(true);

        usuario = usuarioRepository.save(usuario);

        // 2) Crear su registro de auth con password encriptado
        UsuarioAuth auth = new UsuarioAuth();
        auth.setUsuario(usuario);
        auth.setPasswordHash(passwordEncoder.encode(rawPassword));

        usuarioAuthRepository.save(auth);

        System.out.println("Usuario creado: " + email + " / contraseña: " + rawPassword);
    }
}