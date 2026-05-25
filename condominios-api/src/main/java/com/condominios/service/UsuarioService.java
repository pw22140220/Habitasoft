package com.condominios.service;

import com.condominios.dto.CambioPasswordRequest;
import com.condominios.dto.UsuarioPerfilResponse;
import com.condominios.dto.UsuarioRequest;
import com.condominios.dto.UsuarioResponse;
import com.condominios.model.AdminCondominio;
import com.condominios.model.Condominio;
import com.condominios.model.GuardiaCondominio;
import com.condominios.model.ResidenteUnidad;
import com.condominios.model.Unidad;
import com.condominios.model.User;
import com.condominios.model.User.Rol;
import com.condominios.repository.AdminCondominioRepository;
import com.condominios.repository.CondominioRepository;
import com.condominios.repository.GuardiaCondominioRepository;
import com.condominios.repository.ResidenteUnidadRepository;
import com.condominios.repository.UnidadRepository;
import com.condominios.repository.UserRepository;
import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
public class UsuarioService {

    private final UserRepository userRepository;
    private final UnidadRepository unidadRepository;
    private final CondominioRepository condominioRepository;
    private final ResidenteUnidadRepository residenteUnidadRepository;
    private final AdminCondominioRepository adminCondominioRepository;
    private final GuardiaCondominioRepository guardiaCondominioRepository;
    private final PasswordEncoder passwordEncoder;

    public UsuarioService(UserRepository userRepository,
                          UnidadRepository unidadRepository,
                          CondominioRepository condominioRepository,
                          ResidenteUnidadRepository residenteUnidadRepository,
                          AdminCondominioRepository adminCondominioRepository,
                          GuardiaCondominioRepository guardiaCondominioRepository,
                          PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.unidadRepository = unidadRepository;
        this.condominioRepository = condominioRepository;
        this.residenteUnidadRepository = residenteUnidadRepository;
        this.adminCondominioRepository = adminCondominioRepository;
        this.guardiaCondominioRepository = guardiaCondominioRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public UsuarioResponse crear(UsuarioRequest request, Long adminId, Long condominioId) {
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "El email ya está registrado");
        }

        User user = new User();
        user.setNombre(request.getNombre());
        user.setEmail(request.getEmail());

        String password = request.getPassword();
        if (password == null || password.isBlank()) {
            password = "default123";
        }
        user.setPasswordHash(passwordEncoder.encode(password));

        user.setTelefono(request.getTelefono());
        user.setRol(request.getRol() != null ? request.getRol() : Rol.residente);
        user = userRepository.save(user);

        if (user.getRol() == Rol.residente) {
            Long unidadId = resolverUnidad(request, condominioId);
            if (unidadId != null) {
                asignarUnidad(user.getId(), unidadId, condominioId);
            } else {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "Debe especificar una unidad existente (unidadId) o una nueva (nuevaUnidadNumero)");
            }
        } else if (user.getRol() == Rol.guardia) {
            Long guardiaCondominioId = request.getCondominioId() != null
                    ? request.getCondominioId() : condominioId;
            GuardiaCondominio gc = new GuardiaCondominio(user.getId(), guardiaCondominioId);
            guardiaCondominioRepository.save(gc);
        }

        return toResponse(user);
    }

    public Page<UsuarioResponse> listarPorCondominio(Long condominioId, Pageable pageable, String search) {
        Page<User> usuarios;
        if (search != null && !search.isBlank()) {
            usuarios = userRepository.searchByCondominioId(condominioId, search, pageable);
        } else {
            usuarios = userRepository.findByCondominioId(condominioId, pageable);
        }
        return usuarios.map(this::toResponse);
    }

    public UsuarioResponse obtenerPorId(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Usuario no encontrado"));
        return toResponse(user);
    }

    @Transactional
    public UsuarioResponse actualizar(Long id, UsuarioRequest request, Long condominioId) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        user.setNombre(request.getNombre());
        user.setEmail(request.getEmail());
        user.setTelefono(request.getTelefono());
        user.setRol(request.getRol());

        if (request.getPassword() != null && !request.getPassword().isBlank()) {
            user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        }

        user = userRepository.save(user);

        if (user.getRol() == Rol.residente) {
            residenteUnidadRepository.deleteByIdResidenteId(user.getId());
            Long unidadId = resolverUnidad(request, condominioId);
            if (unidadId != null) {
                asignarUnidad(user.getId(), unidadId, condominioId);
            }
        } else if (user.getRol() == Rol.guardia) {
            guardiaCondominioRepository.deleteByGuardiaId(user.getId());
            Long guardiaCondominioId = request.getCondominioId() != null
                    ? request.getCondominioId() : condominioId;
            GuardiaCondominio gc = new GuardiaCondominio(user.getId(), guardiaCondominioId);
            guardiaCondominioRepository.save(gc);
        }

        return toResponse(user);
    }

    @Transactional
    public void eliminar(Long id) {
        if (!userRepository.existsById(id)) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "Usuario no encontrado");
        }
        residenteUnidadRepository.deleteByIdResidenteId(id);
        guardiaCondominioRepository.deleteByGuardiaId(id);
        userRepository.deleteById(id);
    }

    // ==================== PERFIL ====================

    public UsuarioPerfilResponse obtenerPerfil(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Usuario no encontrado"));
        return toPerfilResponse(user);
    }

    @Transactional
    public UsuarioPerfilResponse actualizarPerfil(Long userId, String nombre, String email, String telefono) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        if (!user.getEmail().equals(email) && userRepository.findByEmail(email).isPresent()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "El email ya está en uso");
        }

        user.setNombre(nombre);
        user.setEmail(email);
        user.setTelefono(telefono);

        user = userRepository.save(user);
        return toPerfilResponse(user);
    }

    @Transactional
    public void cambiarPassword(Long userId, CambioPasswordRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        if (!passwordEncoder.matches(request.getPasswordActual(), user.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Contraseña actual incorrecta");
        }

        if (passwordEncoder.matches(request.getPasswordNueva(), user.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "La nueva contraseña debe ser diferente a la actual");
        }

        if (!request.getPasswordNueva().equals(request.getConfirmarPasswordNueva())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Las contraseñas nuevas no coinciden");
        }

        user.setPasswordHash(passwordEncoder.encode(request.getPasswordNueva()));
        userRepository.save(user);
    }

    // ==================== OBTENER CONDOMINIO POR ROL ====================

    public Long obtenerCondominioIdPorAdmin(Long adminId) {
        List<AdminCondominio> lista = adminCondominioRepository
                .findByAdminIdOrderByFechaAsignacionAsc(adminId);
        if (lista.isEmpty()) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "El administrador no tiene condominios asignados");
        }
        return lista.get(0).getCondominioId();
    }

    public Long obtenerCondominioIdPorResidente(Long residenteId) {
        return residenteUnidadRepository.findByIdResidenteId(residenteId)
                .map(ru -> unidadRepository.findById(ru.getId().getUnidadId())
                        .map(Unidad::getCondominioId)
                        .orElseThrow(() -> new ResponseStatusException(
                                HttpStatus.BAD_REQUEST, "La unidad del residente no existe")))
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.BAD_REQUEST, "El residente no tiene una unidad asignada"));
    }

    public Long obtenerCondominioIdPorGuardia(Long guardiaId) {
        return guardiaCondominioRepository.findFirstByGuardiaId(guardiaId)
                .map(GuardiaCondominio::getCondominioId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.BAD_REQUEST, "El guardia no tiene un condominio asignado"));
    }

    public Long obtenerCondominioIdPorUsuario(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        if (user.getRol() == Rol.administrador) {
            return obtenerCondominioIdPorAdmin(userId);
        } else if (user.getRol() == Rol.residente) {
            return obtenerCondominioIdPorResidente(userId);
        } else if (user.getRol() == Rol.guardia) {
            return obtenerCondominioIdPorGuardia(userId);
        } else {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Rol no válido");
        }
    }

    public User obtenerUsuarioPorEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Usuario no encontrado"));
    }

    // ==================== MÉTODOS PRIVADOS ====================

    private Long resolverUnidad(UsuarioRequest request, Long condominioId) {
        if (request.getNuevaUnidadNumero() != null && !request.getNuevaUnidadNumero().isBlank()) {
            String numero = request.getNuevaUnidadNumero().trim();
            if (unidadRepository.existsByNumeroUnidadAndCondominioId(numero, condominioId)) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "La unidad '" + numero + "' ya existe en este condominio");
            }
            Unidad nuevaUnidad = new Unidad();
            nuevaUnidad.setCondominioId(condominioId);
            nuevaUnidad.setNumeroUnidad(numero);
            nuevaUnidad = unidadRepository.save(nuevaUnidad);
            return nuevaUnidad.getId();
        } else if (request.getUnidadId() != null) {
            return request.getUnidadId();
        }
        return null;
    }

    private void asignarUnidad(Long residenteId, Long unidadId, Long condominioId) {
        Unidad unidad = unidadRepository.findByIdAndCondominioId(unidadId, condominioId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.BAD_REQUEST,
                        "La unidad no existe o no pertenece a este condominio"));

        ResidenteUnidad ru = new ResidenteUnidad(residenteId, unidad.getId());
        residenteUnidadRepository.save(ru);
    }

    private UsuarioPerfilResponse toPerfilResponse(User user) {
        UsuarioPerfilResponse response = new UsuarioPerfilResponse();
        response.setId(user.getId());
        response.setNombre(user.getNombre());
        response.setEmail(user.getEmail());
        response.setTelefono(user.getTelefono());
        response.setRol(user.getRol());
        response.setFechaCreacion(user.getFechaCreacion());

        if (user.getRol() == Rol.residente) {
            residenteUnidadRepository.findByIdResidenteId(user.getId())
                    .ifPresent(ru -> unidadRepository.findById(ru.getId().getUnidadId())
                            .ifPresent(u -> response.setNumeroUnidad(u.getNumeroUnidad())));
        }

        return response;
    }

    private UsuarioResponse toResponse(User user) {
        UsuarioResponse response = new UsuarioResponse();
        response.setId(user.getId());
        response.setNombre(user.getNombre());
        response.setEmail(user.getEmail());
        response.setTelefono(user.getTelefono());
        response.setRol(user.getRol());
        response.setFechaCreacion(user.getFechaCreacion());

        if (user.getRol() == Rol.residente) {
            residenteUnidadRepository.findByIdResidenteId(user.getId())
                    .ifPresent(ru -> {
                        unidadRepository.findById(ru.getId().getUnidadId())
                                .ifPresent(u -> {
                                    response.setNumeroUnidad(u.getNumeroUnidad());
                                });
                    });
        } else if (user.getRol() == Rol.guardia) {
            guardiaCondominioRepository.findFirstByGuardiaId(user.getId())
                    .ifPresent(gc -> {
                        condominioRepository.findById(gc.getCondominioId())
                                .ifPresent(c -> response.setCondominioNombre(c.getNombre()));
                    });
        }

        return response;
    }
}
