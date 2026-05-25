package com.condominios.service;

import com.condominios.model.Pago;
import com.condominios.model.User;
import com.condominios.repository.PagoRepository;
import com.condominios.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Service
public class NotificacionService {

    private final UserRepository userRepository;
    private final PagoRepository pagoRepository;

    public NotificacionService(UserRepository userRepository, PagoRepository pagoRepository) {
        this.userRepository = userRepository;
        this.pagoRepository = pagoRepository;
    }

    public void enviarRecordatorioPago(Long residenteId, BigDecimal monto, String periodo, LocalDate fechaVencimiento) {
        User residente = userRepository.findById(residenteId).orElse(null);
        if (residente == null) return;

        StringBuilder mensaje = new StringBuilder();
        mensaje.append("Recordatorio de pago: $").append(monto);
        if (periodo != null) {
            mensaje.append(" correspondiente a ").append(periodo);
        }
        if (fechaVencimiento != null) {
            mensaje.append(". Vence el ").append(fechaVencimiento);
        }

        System.out.println("[NOTIFICACIÓN] Para: " + residente.getEmail()
                + " | Mensaje: " + mensaje);
    }

    public void enviarRecordatorioMasivo() {
        List<Pago> vencidos = pagoRepository.findVencidos(LocalDate.now());

        for (Pago pago : vencidos) {
            User residente = userRepository.findById(pago.getResidenteId()).orElse(null);
            if (residente == null) continue;

            String mensaje = "Tienes un pago vencido de $" + pago.getMonto();
            if (pago.getPeriodo() != null) {
                mensaje += " (" + pago.getPeriodo() + ")";
            }
            mensaje += ". Por favor regulariza tu situacion.";

            System.out.println("[NOTIFICACIÓN MOROSIDAD] Para: " + residente.getEmail()
                    + " | Mensaje: " + mensaje);
        }
    }

    public void enviarNotificacionProximoVencimiento(Pago pago) {
        User residente = userRepository.findById(pago.getResidenteId()).orElse(null);
        if (residente == null) return;

        String mensaje = "Recordatorio: Tu pago de $" + pago.getMonto();
        if (pago.getPeriodo() != null) {
            mensaje += " (" + pago.getPeriodo() + ")";
        }
        mensaje += " vence pronto. Realiza tu pago antes de la fecha limite.";

        System.out.println("[NOTIFICACIÓN PRÓXIMO VENCIMIENTO] Para: " + residente.getEmail()
                + " | Mensaje: " + mensaje);
    }
}
