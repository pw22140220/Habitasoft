package com.condominios.repository;

import com.condominios.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/**
 * Repositorio JPA para la entidad {@link User} (tabla Usuarios).
 */
public interface UserRepository extends JpaRepository<User, Long> {

    /**
     * Busca un usuario por su email (columna UNIQUE en la BD).
     */
    Optional<User> findByEmail(String email);
}
