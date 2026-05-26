import 'package:flutter/material.dart';
import 'watchman_alerts_screen.dart';
import 'watchman_qr_scanner_screen.dart';
import 'watchman_incidents_screen.dart';
import 'watchman_history_screen.dart';
import 'watchman_announcements_screen.dart';

const double kCardsOverlap = 33;
const double kBlueExtraHeight = 60;
const Color kPrimaryGreen = Color(0xFF15806C);
const Color kPrimaryBlue = Color(0xFF0B64D8);
const Color kLightGray = Color(0xFFF5F6FA);
const Color kCardShadow = Color(0x0A000000);

class WatchmanDashboardScreen extends StatelessWidget {
  final String userName;
  final String? token;

  const WatchmanDashboardScreen({
    super.key,
    required this.userName,
    this.token,
  });

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
              _AnnouncementsPreviewSection(token: token),
            ],
          ),
        ),
      ),
    );
  }
}

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dashboard Vigilante',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WatchmanAlertsScreen(token: token),
                      ),
                    ),
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
            'Bienvenido,\n$userName!',
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
            'Control de acceso y seguridad',
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
            icon: Icons.qr_code_scanner,
            label: 'Escanear QR',
            subtitle: 'Validar acceso',
            color: const Color(0xFF4CAF50),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => WatchmanQRScannerScreen(
                          userName: userName,
                          token: token,
                        ),
                  ),
                ),
          ),
          _DashboardCard(
            icon: Icons.announcement_outlined,
            label: 'Avisos del Admin',
            subtitle: 'Comunicados importantes',
            color: const Color(0xFF2196F3),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => WatchmanAnnouncementsScreen(
                          userName: userName,
                          token: token,
                        ),
                  ),
                ),
          ),
          _DashboardCard(
            icon: Icons.security,
            label: 'Incidentes',
            subtitle: 'Reportar problemas',
            color: const Color(0xFFFF9800),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => WatchmanIncidentsScreen(
                          userName: userName,
                          token: token,
                        ),
                  ),
                ),
          ),
          _DashboardCard(
            icon: Icons.history,
            label: 'Historial',
            subtitle: 'Registro de accesos',
            color: const Color(0xFF9C27B0),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => WatchmanHistoryScreen(
                          userName: userName,
                          token: token,
                        ),
                  ),
                ),
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

class _AnnouncementsPreviewSection extends StatelessWidget {
  final String? token;
  const _AnnouncementsPreviewSection({this.token});

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
                'Avisos Recientes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              TextButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WatchmanAlertsScreen(token: token),
                      ),
                    ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: _AnnouncementCard(),
        ),
        const SizedBox(height: 24),
      ],
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
                  Icons.security,
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
                      'Hace 1 hora',
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
            'Recordatorio: Verificar identificación de todos los visitantes después de las 8:00 PM. Reportar cualquier actividad sospechosa inmediatamente.',
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
                  'Seguridad',
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
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => WatchmanQRScannerScreen(
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
            builder: (_) => WatchmanAlertsScreen(token: widget.token),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => WatchmanHistoryScreen(
                  userName: widget.userName,
                  token: widget.token,
                ),
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => WatchmanIncidentsScreen(
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
            icon: Icon(Icons.qr_code_scanner_outlined, size: 24),
            activeIcon: Icon(Icons.qr_code_scanner, size: 24),
            label: 'Escanear',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none, size: 24),
            activeIcon: Icon(Icons.notifications, size: 24),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 24),
            activeIcon: Icon(Icons.history, size: 24),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_outlined, size: 24),
            activeIcon: Icon(Icons.report, size: 24),
            label: 'Incidentes',
          ),
        ],
      ),
    );
  }
}
