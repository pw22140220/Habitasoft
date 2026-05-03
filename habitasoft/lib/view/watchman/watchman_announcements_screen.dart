import 'package:flutter/material.dart';

class WatchmanAnnouncementsScreen extends StatelessWidget {
  final String userName;

  const WatchmanAnnouncementsScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avisos del Administrador'),
        backgroundColor: const Color(0xFF15806C),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Filtros
          Container(
            padding: const EdgeInsets.all(16),
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
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filtrar por:',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFilterChip('Todos', true),
                    _buildFilterChip('Seguridad', false),
                    _buildFilterChip('Mantenimiento', false),
                    _buildFilterChip('Urgente', false),
                    _buildFilterChip('General', false),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Lista de avisos
          _buildAnnouncementCard(
            title: 'Protocolo de Seguridad Nocturna',
            description:
                'A partir de hoy, todos los visitantes después de las 8:00 PM deben presentar identificación oficial y ser registrados en el sistema. Reportar cualquier actividad sospechosa inmediatamente.',
            author: 'Administración',
            time: 'Hoy, 9:00 AM',
            category: 'Seguridad',
            categoryColor: Colors.red,
            isImportant: true,
            hasAttachment: true,
          ),
          _buildAnnouncementCard(
            title: 'Mantenimiento de Cámaras de Seguridad',
            description:
                'El próximo viernes 26 de abril se realizará mantenimiento preventivo a las cámaras de seguridad de 10:00 AM a 2:00 PM. Durante este tiempo, aumentar vigilancia en áreas críticas.',
            author: 'Departamento de Mantenimiento',
            time: 'Ayer, 3:30 PM',
            category: 'Mantenimiento',
            categoryColor: Colors.orange,
            isImportant: true,
            hasAttachment: false,
          ),
          _buildAnnouncementCard(
            title: 'Entrega de Paquetes Especiales',
            description:
                'Se espera entrega de equipo de oficina para el área administrativa. Verificar identificación del repartidor y solicitar firma de recibido.',
            author: 'Administración',
            time: 'Ayer, 11:15 AM',
            category: 'General',
            categoryColor: Colors.blue,
            isImportant: false,
            hasAttachment: false,
          ),
          _buildAnnouncementCard(
            title: 'Corte Programado de Energía',
            description:
                'El sábado 27 de abril habrá corte programado de energía de 8:00 AM a 12:00 PM para mantenimiento del transformador principal. Preparar linternas y verificar funcionamiento de puertas eléctricas.',
            author: 'Servicios Generales',
            time: '2 días atrás',
            category: 'Mantenimiento',
            categoryColor: Colors.orange,
            isImportant: true,
            hasAttachment: true,
          ),
          _buildAnnouncementCard(
            title: 'Nuevo Procedimiento de Acceso',
            description:
                'Implementación de nuevo sistema de registro digital para proveedores. A partir de la próxima semana, todos los proveedores deben registrarse mediante la aplicación móvil.',
            author: 'Administración',
            time: '3 días atrás',
            category: 'Seguridad',
            categoryColor: Colors.red,
            isImportant: false,
            hasAttachment: false,
          ),
          _buildAnnouncementCard(
            title: 'Reunión Mensual de Seguridad',
            description:
                'Recordatorio: Reunión mensual de seguridad el próximo lunes 28 de abril a las 10:00 AM en la sala de juntas. Temas: revisión de incidentes y actualización de protocolos.',
            author: 'Jefe de Seguridad',
            time: '4 días atrás',
            category: 'Seguridad',
            categoryColor: Colors.red,
            isImportant: true,
            hasAttachment: true,
          ),
          _buildAnnouncementCard(
            title: 'Actualización de Equipo',
            description:
                'Se ha instalado nuevo sistema de comunicación en la caseta de vigilancia. Verificar funcionamiento y reportar cualquier anomalía.',
            author: 'Tecnología',
            time: '5 días atrás',
            category: 'General',
            categoryColor: Colors.blue,
            isImportant: false,
            hasAttachment: false,
          ),
          _buildAnnouncementCard(
            title: 'Horario de Verano',
            description:
                'Ajuste de horario de vigilancia para el periodo de verano. Turno nocturno inicia a las 7:00 PM en lugar de 6:00 PM.',
            author: 'Recursos Humanos',
            time: '1 semana atrás',
            category: 'General',
            categoryColor: Colors.blue,
            isImportant: false,
            hasAttachment: false,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (bool value) {
        // TODO: Implementar filtrado
      },
      selectedColor: const Color(0xFF15806C),
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(color: selected ? Colors.white : Colors.grey[700]),
    );
  }

  Widget _buildAnnouncementCard({
    required String title,
    required String description,
    required String author,
    required String time,
    required String category,
    required Color categoryColor,
    required bool isImportant,
    required bool hasAttachment,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          color:
              isImportant ? categoryColor.withOpacity(0.3) : Colors.grey[200]!,
          width: isImportant ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isImportant)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.priority_high,
                              size: 12,
                              color: Colors.red,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'URGENTE',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 11,
                          color: categoryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (hasAttachment)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.attach_file,
                              size: 12,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Adjunto',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Separador
          Container(height: 1, color: Colors.grey[100]),

          // Contenido
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Por: $author',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // TODO: Implementar marcar como leído
                          },
                          icon: const Icon(
                            Icons.check,
                            size: 20,
                            color: Colors.grey,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        IconButton(
                          onPressed: () {
                            // TODO: Implementar compartir
                          },
                          icon: const Icon(
                            Icons.share,
                            size: 20,
                            color: Colors.grey,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
