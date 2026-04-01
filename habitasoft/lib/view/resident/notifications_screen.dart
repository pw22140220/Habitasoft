import 'package:flutter/material.dart';

// 1. MODELO DE DATOS
class NotificacionAdmin {
  final String titulo;
  final String mensaje;
  final String hora;
  final String tipo; // 'pago', 'reserva', 'servicio', 'comunidad'

  NotificacionAdmin({
    required this.titulo,
    required this.mensaje,
    required this.hora,
    required this.tipo,
  });
}

// 2. DATOS SIMULADOS (Aquí llegarán los del Admin)
List<NotificacionAdmin> mensajesDelAdmin = [
  NotificacionAdmin(
    tipo: 'pago',
    titulo: 'New Dues Reminder',
    mensaje: 'Your payment is due soon. Don\'t forget to pay your dues!',
    hora: '2 min ago',
  ),
  NotificacionAdmin(
    tipo: 'reserva',
    titulo: 'Amenity Booking Confirmed',
    mensaje: 'Your pool booking for Saturday is confirmed.',
    hora: '5 min ago',
  ),
  NotificacionAdmin(
    tipo: 'servicio',
    titulo: 'Service Request Update',
    mensaje: 'Your service request has been marked as completed.',
    hora: '10 min ago',
  ),
  NotificacionAdmin(
    tipo: 'comunidad',
    titulo: 'New Community Post',
    mensaje: 'Check out the latest post in the community feed.',
    hora: '15 min ago',
  ),
  NotificacionAdmin(
    tipo: 'comunidad',
    titulo: 'Water Supply Alert',
    mensaje: 'Maintenance scheduled for tomorrow at 9 AM.',
    hora: '1 hour ago',
  ),
];

// 3. PANTALLA PRINCIPAL DE NOTIFICACIONES
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Stack(
        children: [
          Column(
            children: [
              // HEADER
              Container(
                width: double.infinity,
                height: 130, // Un poco más compacto para sub-pantalla
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                color: const Color(0xFF00796B),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón atrás
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Notifications",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Contador
                    Stack(
                      children: [
                        const Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 28,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${mensajesDelAdmin.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // LISTA
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 0,
                    ),
                    itemCount: mensajesDelAdmin.length,
                    itemBuilder: (context, index) {
                      return TarjetaNotificacion(
                        datos: mensajesDelAdmin[index],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          // BOTÓN FLOTANTE
          Positioned(
            top: 105,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  "Mark All as Read",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 4. TARJETA INDIVIDUAL
class TarjetaNotificacion extends StatelessWidget {
  final NotificacionAdmin datos;
  const TarjetaNotificacion({super.key, required this.datos});

  @override
  Widget build(BuildContext context) {
    final bool esPago = datos.tipo == 'pago';
    final Color colorFondo =
        esPago ? const Color(0xFFFFEBEE) : const Color(0xFFE3F2FD);
    final Color colorIcono =
        esPago ? const Color(0xFFD32F2F) : const Color(0xFF1976D2);

    IconData icono;
    if (datos.tipo == 'pago')
      icono = Icons.description;
    else if (datos.tipo == 'reserva')
      icono = Icons.event_available;
    else if (datos.tipo == 'servicio')
      icono = Icons.build;
    else
      icono = Icons.chat_bubble_outline;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: colorFondo,
              shape: BoxShape.circle,
            ),
            child: Icon(icono, color: colorIcono, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      datos.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      datos.hora,
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  datos.mensaje,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
