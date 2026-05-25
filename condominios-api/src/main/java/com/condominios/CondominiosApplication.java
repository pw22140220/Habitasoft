package com.condominios;

import com.condominios.model.User;
import com.condominios.model.User.Rol;
import com.condominios.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * Punto de entrada de la aplicación Spring Boot.
 *
 * Incluye un CommandLineRunner para sembrar datos de prueba
 * si la tabla Usuarios está vacía. Cada usuario se crea con
 * su rol correspondiente para que el frontend pueda distinguirlos.
 */
@SpringBootApplication
@EnableScheduling
public class CondominiosApplication {

    public static void main(String[] args) {
        SpringApplication.run(CondominiosApplication.class, args);
    }

    /**
     * Crea usuarios de prueba al iniciar la aplicación (solo la primera vez).
     *
     * Usuarios creados:
     *   admin@habitasoft.com / admin123   → rol: administrador
     *   juan@example.com     / juan123    → rol: residente
     *   carlos@example.com   / carlos123  → rol: residente
     */
    @Bean
    public CommandLineRunner initData(UserRepository userRepository,
                                       PasswordEncoder passwordEncoder) {
        return args -> {

            crearUsuarioSiNoExiste(
                    "Administrador General",
                    "admin@habitasoft.com",
                    "7220000000",
                    Rol.administrador,
                    "admin123",
                    userRepository,
                    passwordEncoder
            );

            crearUsuarioSiNoExiste(
                    "Juan Pérez",
                    "juan@example.com",
                    "7221234567",
                    Rol.residente,
                    "juan123",
                    userRepository,
                    passwordEncoder
            );

            crearUsuarioSiNoExiste(
                    "Carlos López",
                    "carlos@example.com",
                    "7220001111",
                    Rol.guardia,
                    "carlos123",
                    userRepository,
                    passwordEncoder
            );
            crearUsuarioSiNoExiste(
                    "Carlos López",
                    "cesar@example.com",
                    "7220001111",
                    Rol.guardia,
                    "cesar123",
                    userRepository,
                    passwordEncoder
            );
            
        };
    }

    /**
     * Crea un usuario en la tabla Usuarios solo si no existe ya
     * un registro con el mismo email.
     */
    private void crearUsuarioSiNoExiste(String nombre,
                                         String email,
                                         String telefono,
                                         Rol rol,
                                         String rawPassword,
                                         UserRepository userRepository,
                                         PasswordEncoder passwordEncoder) {

        if (userRepository.findByEmail(email).isPresent()) {
            System.out.println("Usuario ya existe, no se crea de nuevo: " + email);
            return;
        }

        User user = new User();
        user.setNombre(nombre);
        user.setEmail(email);
        user.setTelefono(telefono);
        user.setRol(rol);
        user.setPasswordHash(passwordEncoder.encode(rawPassword));

        userRepository.save(user);

        System.out.println("Usuario creado: " + email + " / rol: " + rol);
    }
}
