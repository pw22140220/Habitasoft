package com.condominios.repository;

import com.condominios.model.AdminCondominio;
import com.condominios.model.AdminCondominio.AdminCondominioId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface AdminCondominioRepository extends JpaRepository<AdminCondominio, AdminCondominioId> {

    @Query("SELECT ac FROM AdminCondominio ac WHERE ac.id.adminId = :adminId ORDER BY ac.fechaAsignacion ASC")
    List<AdminCondominio> findByAdminIdOrderByFechaAsignacionAsc(@Param("adminId") Long adminId);
}
