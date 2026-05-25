import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'amenities_screen.dart';
import 'notifications_screen.dart';
import 'qr_generation_screen.dart';
import 'announcements_screen.dart';
import 'payment_reminders_screen.dart';
import '../../services/anuncio_service.dart';
import '../../services/auth_service.dart';
import '../../models/anuncio_model.dart';

// ====== CONSTANTES DE DISEÑO ======
const double kCardsOverlap = 33;
const double kBlueExtraHeight = 60;
const Color kPrimaryGreen = Color(0xFF15806C);
const Color kPrimaryBlue = Color(0xFF0B64D8);
const Color kLightGray = Color(0xFFF5F6FA);
const Color kCardShadow = Color(0x0A000000);
// ==================================

class DashboardScreen extends StatelessWidget {
  final String userName;
  final String? token;

  const DashboardScreen({super.key, required this.userName, this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGray,
      bottomNavigationBar: _BottomNavBar(userName: userName, token: token),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _Header(userName: userName, token: token),
              Transform.translate(
                offset: const Offset(0, -kCardsOverlap),
                child: _OptionsGrid(userName: userName, token: token),
              ),
              const SizedBox(height: kCardsOverlap),
              _AnnouncementsPreviewSection(userName: userName, token: token),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== HEADER MODERNO ==================

class _Header extends StatelessWidget {
  final String userName;
  final String? token;

  const _Header({required this.userName, this.token});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: kBlueExtraHeight,
      ),
      decoration: const BoxDecoration(
        color: kPrimaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FILA SUPERIOR: Dashboard + Notificaciones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NotificationsScreen(token: token),
                    ),
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                    color: kPrimaryGreen,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome Home,\n$userName!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage your condominium services',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ================== GRID DE MÓDULOS PRINCIPALES ==================

class _OptionsGrid extends StatelessWidget {
  final String userName;
  final String? token;
  const _OptionsGrid({required this.userName, this.token});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.1,
        children: [
          _DashboardCard(
            icon: Icons.qr_code_2_outlined,
            label: 'Generar QR Visitas',
            subtitle: 'Acceso para invitados',
            color: const Color(0xFF4CAF50),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) =>
                          QRGenerationScreen(userName: userName, token: token),
                ),
              );
            },
          ),
          _DashboardCard(
            icon: Icons.calendar_today_outlined,
            label: 'Reservar Amenidades',
            subtitle: 'Áreas comunes',
            color: const Color(0xFF2196F3),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => AmenitiesScreen(userName: userName, token: token),
                ),
              );
            },
          ),
          _DashboardCard(
            icon: Icons.announcement_outlined,
            label: 'Anuncios Comunitarios',
            subtitle: 'Avisos del administrador',
            color: const Color(0xFFFF9800),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) =>
                          AnnouncementsScreen(userName: userName, token: token),
                ),
              );
            },
          ),
          _DashboardCard(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Recordatorios de Pago',
            subtitle: 'Cuotas pendientes',
            color: const Color(0xFF9C27B0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => PaymentRemindersScreen(
                        userName: userName,
                        token: token,
                      ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kCardShadow,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          splashColor: color.withOpacity(0.1),
          highlightColor: color.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 28, color: color),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================== VISTA PREVIA DE ANUNCIOS ==================

class _AnnouncementsPreviewSection extends StatefulWidget {
  final String userName;
  final String? token;

  const _AnnouncementsPreviewSection({required this.userName, this.token});

  @override
  State<_AnnouncementsPreviewSection> createState() =>
      _AnnouncementsPreviewSectionState();
}

class _AnnouncementsPreviewSectionState
    extends State<_AnnouncementsPreviewSection> {
  List<Anuncio> _anuncios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final condominioId = await AuthService.obtenerCondominioId(widget.token);
    try {
      final service = AnuncioService(token: widget.token);
      final anuncios = await service.listarResidente(condominioId);
      anuncios.sort((a, b) {
        if (a.destacado != b.destacado) return b.destacado ? 1 : -1;
        final fa = a.fechaCreacion ?? '';
        final fb = b.fechaCreacion ?? '';
        return fb.compareTo(fa);
      });
      if (mounted) setState(() => _anuncios = anuncios.take(2).toList());
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Anuncios Recientes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => AnnouncementsScreen(
                            userName: widget.userName,
                            token: widget.token,
                          ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Ver todos',
                  style: TextStyle(
                    fontSize: 14,
                    color: kPrimaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          )
        else if (_anuncios.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: kCardShadow,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'No hay anuncios recientes',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          )
        else
          ...List.generate(
            _anuncios.length,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
              child: _MiniAnuncioCard(anuncio: _anuncios[i]),
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _MiniAnuncioCard extends StatelessWidget {
  final Anuncio anuncio;
  const _MiniAnuncioCard({required this.anuncio});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
            anuncio.destacado
                ? Border.all(color: const Color(0xFFFF9800), width: 1.5)
                : null,
        boxShadow: [
          BoxShadow(
            color: kCardShadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            anuncio.destacado ? Icons.star : Icons.campaign_outlined,
            color: anuncio.destacado ? const Color(0xFFFF9800) : kPrimaryBlue,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  anuncio.titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  anuncio.contenido,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF555555),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kCardShadow,
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
                  color: kPrimaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.apartment,
                  color: kPrimaryGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Administración del Condominio',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Hace 2 horas',
                      style: TextStyle(
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
          const Text(
            'Recordatorio: Mantenimiento programado del ascensor este viernes de 9:00 AM a 1:00 PM. Por favor, planifique sus actividades en consecuencia.',
            style: TextStyle(
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
                  color: kPrimaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Importante',
                  style: TextStyle(
                    fontSize: 11,
                    color: kPrimaryGreen,
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

// ================== BOTTOM NAVIGATION BAR MEJORADO ==================

class _BottomNavBar extends StatefulWidget {
  final String userName;
  final String? token;

  const _BottomNavBar({required this.userName, this.token});

  @override
  State<_BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<_BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Ya estamos en el Dashboard
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => AmenitiesScreen(
                  userName: widget.userName,
                  token: widget.token,
                ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NotificationsScreen(token: widget.token),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => ProfileScreen(
                  userName: widget.userName,
                  token: widget.token,
                ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: kPrimaryBlue,
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
