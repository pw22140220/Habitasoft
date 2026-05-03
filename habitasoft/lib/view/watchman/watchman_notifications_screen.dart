import 'package:flutter/material.dart';

class WatchmanNotificationsScreen extends StatelessWidget {
  const WatchmanNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: const Color(0xFF15806C),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationCard(
            title: 'QR Escaneado Exitosamente',
            description:
                'Visitante: Juan Pérez - Departamento: 402 - Hora: 14:30',
            time: 'Hace 5 minutos',
            icon: Icons.qr_code_scanner,
            color: Colors.green,
            isRead: false,
          ),
          _buildNotificationCard(
            title: 'Acceso Denegado',
            description:
                'QR inválido o expirado - Intento de acceso a las 13:45',
            time: 'Hace 1 hora',
            icon: Icons.warning,
            color: Colors.orange,
            isRead: true,
          ),
          _buildNotificationCard(
            title: 'Nuevo Aviso del Admin',
            description:
                'Recordatorio: Verificación de identificación nocturna',
            time: 'Hace 2 horas',
            icon: Icons.announcement,
            color: Colors.blue,
            isRead: true,
          ),
          _buildNotificationCard(
            title: 'Reporte de Incidente',
            description: 'Luz del estacionamiento sección B no funciona',
            time: 'Hace 3 horas',
            icon: Icons.report,
            color: Colors.red,
            isRead: true,
          ),
          _buildNotificationCard(
            title: 'Cambio de Turno',
            description: 'Turno nocturno: 8:00 PM - 6:00 AM',
            time: 'Hace 5 horas',
            icon: Icons.schedule,
            color: Colors.purple,
            isRead: true,
          ),
          _buildNotificationCard(
            title: 'Entrega de Paquete',
            description:
                'Paquete para Departamento 305 - Firmado por residente',
            time: 'Ayer, 10:15 AM',
            icon: Icons.local_shipping,
            color: Colors.teal,
            isRead: true,
          ),
          _buildNotificationCard(
            title: 'Mantenimiento Programado',
            description:
                'Ascensor en mantenimiento mañana de 9:00 AM a 12:00 PM',
            time: 'Ayer, 4:30 PM',
            icon: Icons.engineering,
            color: Colors.brown,
            isRead: true,
          ),
          _buildNotificationCard(
            title: 'Visita Autorizada',
            description: 'Técnico de servicio autorizado para Departamento 208',
            time: 'Ayer, 2:00 PM',
            icon: Icons.verified_user,
            color: Colors.green,
            isRead: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String description,
    required String time,
    required IconData icon,
    required Color color,
    required bool isRead,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isRead ? Colors.grey[200]! : color.withOpacity(0.3),
          width: isRead ? 1 : 2,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
            color: isRead ? Colors.grey[800] : color,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(time, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          ],
        ),
        trailing:
            !isRead
                ? Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                )
                : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        onTap: () {
          // TODO: Implementar vista detallada de notificación
        },
      ),
    );
  }
}
