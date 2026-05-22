package com.condominios.repository;

import com.condominios.model.UsuarioAuth;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UsuarioAuthRepository extends JpaRepository<UsuarioAuth, Long> {
}