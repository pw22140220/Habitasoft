package com.condominios.service;

import com.condominios.dto.PagoRecordatorioRequest;
import com.condominios.dto.PagoRecordatorioResponse;
import com.condominios.model.Pago;
import com.condominios.model.Pago.Estado;
import com.condominios.model.Pago.MetodoPago;
import com.condominios.model.User;
import com.condominios.repository.PagoRepository;
import com.condominios.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Service
public class PagoService {

    private static final Logger log = LoggerFactory.getLogger(PagoService.class);

    private final PagoRepository pagoRepository;
    private final UserRepository userRepository;
    private final NotificacionService notificacionService;

    public PagoService(PagoRepository pagoRepository,
                       UserRepository userRepository,
                       NotificacionService notificacionService) {
        this.pagoRepository = pagoRepository;
        this.userRepository = userRepository;
        this.notificacionService = notificacionService;
    }

    @Transactional
    public void actualizarPagosVencidos() {
        LocalDate hoy = LocalDate.now();
        int actualizados = pagoRepository.marcarVencidos(hoy);
        if (actualizados > 0) {
            log.info("Se actualizaron {} pagos a estado vencido", actualizados);
        }
    }

    @Scheduled(cron = "0 0 1 * * ?")
    @Transactional
    public void schedulerActualizarPagosVencidos() {
        log.info("Ejecutando tarea programada: actualizar pagos vencidos");
        actualizarPagosVencidos();
    }

    public PagoRecordatorioResponse crearRecordatorio(PagoRecordatorioRequest request) {
        User residente = userRepository.findById(request.getResidenteId())
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Residente no encontrado"));

        if (!"residente".equals(residente.getRol().name())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "El usuario seleccionado no es un residente");
        }

        Pago pago = new Pago();
        pago.setResidenteId(request.getResidenteId());
        pago.setMonto(request.getMonto());
        pago.setPeriodo(request.getPeriodo());
        pago.setFechaVencimiento(request.getFechaVencimiento());
        pago.setEstado(Estado.pendiente);

        Pago saved = pagoRepository.save(pago);

        notificacionService.enviarRecordatorioPago(
                request.getResidenteId(),
                request.getMonto(),
                request.getPeriodo(),
                request.getFechaVencimiento()
        );

        return toResponse(saved, residente.getNombre());
    }

    @Transactional
    public Page<PagoRecordatorioResponse> listarPorCondominio(Long condominioId, String estadoFiltro, Pageable pageable) {
        actualizarPagosVencidos();
        Page<Pago> pagos;
        if (estadoFiltro != null && !estadoFiltro.isEmpty()) {
            Estado estado = Estado.valueOf(estadoFiltro);
            pagos = pagoRepository.findByCondominioIdAndEstado(condominioId, estado, pageable);
        } else {
            pagos = pagoRepository.findByCondominioId(condominioId, pageable);
        }
        return pagos.map(p -> {
            String nombre = userRepository.findById(p.getResidenteId())
                    .map(User::getNombre)
                    .orElse("Desconocido");
            return toResponse(p, nombre);
        });
    }

    @Transactional
    public Page<PagoRecordatorioResponse> listarPorResidente(Long residenteId, Long condominioId, Pageable pageable) {
        actualizarPagosVencidos();
        Page<Pago> pagos = pagoRepository.findByResidenteIdAndCondominioId(residenteId, condominioId, pageable);
        return pagos.map(p -> {
            String nombre = userRepository.findById(p.getResidenteId())
                    .map(User::getNombre)
                    .orElse("Desconocido");
            return toResponse(p, nombre);
        });
    }

    @Transactional
    public Page<PagoRecordatorioResponse> listarMisPagos(Long residenteId, Pageable pageable) {
        actualizarPagosVencidos();
        Page<Pago> pagos = pagoRepository.findByResidenteId(residenteId, pageable);
        return pagos.map(p -> {
            String nombre = userRepository.findById(p.getResidenteId())
                    .map(User::getNombre)
                    .orElse("Desconocido");
            return toResponse(p, nombre);
        });
    }

    @Transactional
    public PagoRecordatorioResponse marcarComoPagado(Long pagoId, Long residenteId, String metodoPago) {
        Pago pago = pagoRepository.findById(pagoId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Pago no encontrado"));

        if (!pago.getResidenteId().equals(residenteId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "Este pago no pertenece al residente autenticado");
        }

        if (pago.getEstado() == Estado.pagado) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Este pago ya fue registrado como pagado");
        }

        pago.setEstado(Estado.pagado);
        pago.setFechaPago(LocalDateTime.now());

        if (metodoPago != null) {
            try {
                pago.setMetodoPago(MetodoPago.valueOf(metodoPago));
            } catch (IllegalArgumentException e) {
                pago.setMetodoPago(MetodoPago.transferencia);
            }
        } else {
            pago.setMetodoPago(MetodoPago.transferencia);
        }

        Pago saved = pagoRepository.save(pago);
        String nombre = userRepository.findById(saved.getResidenteId())
                .map(User::getNombre).orElse("Desconocido");
        return toResponse(saved, nombre);
    }

    @Transactional
    public PagoRecordatorioResponse registrarPagoManual(Long pagoId, String metodoPago) {
        Pago pago = pagoRepository.findById(pagoId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Pago no encontrado"));

        if (pago.getEstado() == Estado.pagado) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Este pago ya fue registrado como pagado");
        }

        pago.setEstado(Estado.pagado);
        pago.setFechaPago(LocalDateTime.now());

        if (metodoPago != null) {
            try {
                pago.setMetodoPago(MetodoPago.valueOf(metodoPago));
            } catch (IllegalArgumentException e) {
                pago.setMetodoPago(MetodoPago.efectivo);
            }
        } else {
            pago.setMetodoPago(MetodoPago.efectivo);
        }

        Pago saved = pagoRepository.save(pago);
        String nombre = userRepository.findById(saved.getResidenteId())
                .map(User::getNombre).orElse("Desconocido");
        return toResponse(saved, nombre);
    }

    public void eliminar(Long id) {
        if (!pagoRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Pago no encontrado");
        }
        pagoRepository.deleteById(id);
    }

    @Transactional
    public int marcarVencidos() {
        return pagoRepository.marcarVencidos(LocalDate.now());
    }

    @Transactional
    public void generarRecordatoriosAutomaticos() {
        actualizarPagosVencidos();
        int vencidos = 0;
        if (vencidos > 0) {
            notificacionService.enviarRecordatorioMasivo();
        }
    }

    private PagoRecordatorioResponse toResponse(Pago pago, String residenteNombre) {
        PagoRecordatorioResponse response = new PagoRecordatorioResponse();
        response.setId(pago.getId());
        response.setResidenteId(pago.getResidenteId());
        response.setResidenteNombre(residenteNombre);
        response.setMonto(pago.getMonto());
        response.setPeriodo(pago.getPeriodo());
        response.setFechaVencimiento(pago.getFechaVencimiento());
        response.setEstado(pago.getEstado().name());
        response.setFechaPago(pago.getFechaPago());
        response.setMetodoPago(pago.getMetodoPago() != null ? pago.getMetodoPago().name() : null);
        return response;
    }
}
