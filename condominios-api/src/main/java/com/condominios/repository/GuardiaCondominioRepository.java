package com.condominios.repository;

import com.condominios.model.GuardiaCondominio;
import com.condominios.model.GuardiaCondominio.GuardiaCondominioId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface GuardiaCondominioRepository extends JpaRepository<GuardiaCondominio, GuardiaCondominioId> {

    @Query("SELECT gc FROM GuardiaCondominio gc WHERE gc.id.guardiaId = :guardiaId")
    Optional<GuardiaCondominio> findFirstByGuardiaId(@Param("guardiaId") Long guardiaId);

    @Modifying
    @Query("DELETE FROM GuardiaCondominio gc WHERE gc.id.guardiaId = :guardiaId")
    void deleteByGuardiaId(@Param("guardiaId") Long guardiaId);
}
