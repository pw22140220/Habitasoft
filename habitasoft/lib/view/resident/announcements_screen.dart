import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'profile_screen.dart';

// Pantalla para ver anuncios comunitarios del administrador
class AnnouncementsScreen extends StatelessWidget {
  final String userName;

  const AnnouncementsScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      bottomNavigationBar: _AnnouncementsBottomNavBar(userName: userName),
      body: SafeArea(
        child: Column(
          children: [
            const _AnnouncementsHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _AnnouncementCard(
                      title: 'Mantenimiento de Ascensores',
                      description:
                          'Recordatorio: Mantenimiento programado del ascensor este viernes de 9:00 AM a 1:00 PM. Por favor, planifique sus actividades en consecuencia.',
                      timeAgo: 'Hace 2 horas',
                      priority: 'Importante',
                      priorityColor: const Color(0xFF15806C),
                    ),
                    const SizedBox(height: 12),
                    _AnnouncementCard(
                      title: 'Reunión de Condominio',
                      description:
                          'Se convoca a todos los residentes a la reunión mensual del condominio que se llevará a cabo el próximo martes 28 de enero a las 7:00 PM en el salón comunal.',
                      timeAgo: 'Hace 1 día',
                      priority: 'Información',
                      priorityColor: const Color(0xFF2196F3),
                    ),
                    const SizedBox(height: 12),
                    _AnnouncementCard(
                      title: 'Corte Programado de Agua',
                      description:
                          'Por trabajos de mantenimiento en la red hidráulica, habrá corte de agua este miércoles de 8:00 AM a 12:00 PM. Se recomienda almacenar agua para uso necesario.',
                      timeAgo: 'Hace 3 días',
                      priority: 'Urgente',
                      priorityColor: const Color(0xFFFF9800),
                    ),
                    const SizedBox(height: 12),
                    _AnnouncementCard(
                      title: 'Nuevas Medidas de Seguridad',
                      description:
                          'A partir del próximo mes, se implementarán nuevas medidas de seguridad en el acceso principal. Todos los residentes deberán registrar a sus visitas con 24 horas de anticipación.',
                      timeAgo: 'Hace 5 días',
                      priority: 'Aviso',
                      priorityColor: const Color(0xFF9C27B0),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.announcement_outlined,
                            size: 60,
                            color: Color(0xFFFF9800),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Pantalla en construcción',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Esta pantalla mostrará todos los anuncios y avisos importantes del administrador del condominio.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF666666),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Lógica para marcar como leídos
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9800),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Marcar todos como leídos',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== HEADER DE ANUNCIOS ==================

class _AnnouncementsHeader extends StatelessWidget {
  const _AnnouncementsHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 18),
      decoration: const BoxDecoration(
        color: Color(0xFFFF9800),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          const SizedBox(width: 4),
          const Text(
            'Anuncios Comunitarios',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ================== TARJETA DE ANUNCIO ==================

class _AnnouncementCard extends StatelessWidget {
  final String title;
  final String description;
  final String timeAgo;
  final String priority;
  final Color priorityColor;

  const _AnnouncementCard({
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.priority,
    required this.priorityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.apartment, color: priorityColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeAgo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  priority,
                  style: TextStyle(
                    fontSize: 11,
                    color: priorityColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================== BOTTOM NAVIGATION BAR ==================

class _AnnouncementsBottomNavBar extends StatelessWidget {
  final String userName;

  const _AnnouncementsBottomNavBar({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 2, // Índice para notificaciones
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => DashboardScreen(userName: userName),
                ),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(userName: userName),
                ),
              );
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0B64D8),
        unselectedItemColor: const Color(0xFF9E9E9E),
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24),
            activeIcon: Icon(Icons.home, size: 24),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined, size: 24),
            activeIcon: Icon(Icons.calendar_today, size: 24),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none, size: 24),
            activeIcon: Icon(Icons.notifications, size: 24),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 24),
            activeIcon: Icon(Icons.person, size: 24),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
