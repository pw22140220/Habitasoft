package com.condominios.repository;

import com.condominios.model.User;
import com.condominios.model.User.Rol;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);

    @Query("SELECT DISTINCT u FROM User u " +
           "LEFT JOIN ResidenteUnidad ru ON ru.id.residenteId = u.id " +
           "LEFT JOIN Unidad un ON un.id = ru.id.unidadId " +
           "LEFT JOIN GuardiaCondominio gc ON gc.id.guardiaId = u.id " +
           "WHERE (un.condominioId = :condominioId OR gc.id.condominioId = :condominioId) " +
           "AND u.rol IN ('residente', 'guardia')")
    Page<User> findByCondominioId(@Param("condominioId") Long condominioId,
                                  Pageable pageable);

    @Query("SELECT DISTINCT u FROM User u " +
           "LEFT JOIN ResidenteUnidad ru ON ru.id.residenteId = u.id " +
           "LEFT JOIN Unidad un ON un.id = ru.id.unidadId " +
           "LEFT JOIN GuardiaCondominio gc ON gc.id.guardiaId = u.id " +
           "WHERE (un.condominioId = :condominioId OR gc.id.condominioId = :condominioId) " +
           "AND u.rol IN ('residente', 'guardia') " +
           "AND (LOWER(u.nombre) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "OR LOWER(u.email) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<User> searchByCondominioId(@Param("condominioId") Long condominioId,
                                    @Param("search") String search,
                                    Pageable pageable);
}
