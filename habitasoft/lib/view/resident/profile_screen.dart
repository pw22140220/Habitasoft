import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dashboard.dart';
import 'amenities_screen.dart';
import 'notifications_screen.dart';
import 'account_settings_screen.dart';
import 'privacy_security_screen.dart';
import '../../services/biometric_preferences_service.dart';

// ==== PALETA DE COLORES (MISMO QUE HOME SCREEN) ====
const Color topGreen = Color(0xFF0A896E);
const Color midGreen = Color(0xFF00715D);
const Color bottomGreen = Color(0xFF005E4E);
const Color kPrimaryBlue = Color(0xFF0B64D8); // Para switches y acentos
const Color kLightGray = Color(0xFFF5F6FA);
// ==================================================

class ProfileScreen extends StatefulWidget {
  final String userName;

  const ProfileScreen({super.key, required this.userName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifPrefs = true;
  bool _notifications = true;

  // Datos del usuario (cargados desde shared_preferences)
  String _userFullName = 'Juan Pérez';
  String _userEmail = 'juan.perez@condominio.com';
  String _userUnit = 'Torre A - Apto 301';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Cargar datos del usuario desde shared_preferences
  Future<void> _loadUserData() async {
    final name = await BiometricPreferencesService.getUserName();
    final email = await BiometricPreferencesService.getUserEmail();
    final unit = await BiometricPreferencesService.getUserUnit();

    if (mounted) {
      setState(() {
        _userFullName = name;
        _userEmail = email;
        _userUnit = unit;
      });
    }
  }

  // Función para abrir WhatsApp de soporte
  Future<void> _openWhatsAppSupport() async {
    final phoneNumber = '+521234567890'; // Número de prueba exacto solicitado
    final message = 'Hola, necesito soporte con mi cuenta en Habitasoft.';
    final url = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir WhatsApp. Por favor, instálelo.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGray,
      bottomNavigationBar: _ProfileBottomNavBar(userName: widget.userName),
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER COMPACTO CON INFORMACIÓN =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [topGreen, midGreen, bottomGreen],
                  stops: [0.0, 0.55, 1.0],
                ),
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
                  const Text(
                    'Perfil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Avatar moderno
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(Icons.person, size: 32, color: topGreen),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userFullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _userEmail,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _userUnit,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
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
            const SizedBox(height: 24),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // ===== INFORMACIÓN DEL USUARIO (Card) =====
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Información Personal',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(
                            icon: Icons.person_outline,
                            label: 'Nombre',
                            value: _userFullName,
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: _userEmail,
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(
                            icon: Icons.apartment_outlined,
                            label: 'Unidad',
                            value: _userUnit,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ===== CONFIGURACIONES =====
                  const Text(
                    'Configuraciones',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.settings_outlined,
                            color: Color(0xFF555555),
                          ),
                          title: const Text(
                            'Configuración de Cuenta',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AccountSettingsScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          leading: const Icon(
                            Icons.notifications_outlined,
                            color: Color(0xFF555555),
                          ),
                          title: const Text(
                            'Preferencias de Notificaciones',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Switch(
                            value: _notifPrefs,
                            activeColor: kPrimaryBlue,
                            onChanged: (value) {
                              setState(() => _notifPrefs = value);
                            },
                          ),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          leading: const Icon(
                            Icons.chat_bubble_outline,
                            color: Color(0xFF555555),
                          ),
                          title: const Text(
                            'Notificaciones',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: const Text('13 no leídas'),
                          trailing: Switch(
                            value: _notifications,
                            activeColor: kPrimaryBlue,
                            onChanged: (value) {
                              setState(() => _notifications = value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ===== AYUDA Y SOPORTE =====
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.help_outline,
                            color: Color(0xFF555555),
                          ),
                          title: const Text(
                            'Ayuda y Soporte',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: const Text('Contactar por WhatsApp'),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                          onTap: _openWhatsAppSupport,
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          leading: const Icon(
                            Icons.security_outlined,
                            color: Color(0xFF555555),
                          ),
                          title: const Text(
                            'Privacidad y Seguridad',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PrivacySecurityScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          leading: const Icon(
                            Icons.logout_outlined,
                            color: Color(0xFFD32F2F),
                          ),
                          title: const Text(
                            'Cerrar Sesión',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFD32F2F),
                            ),
                          ),
                          onTap: () {
                            // TODO: Implementar logout
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== FILA DE INFORMACIÓN PERSONAL =====

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF555555), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ===== BOTTOM NAV BAR (IGUAL AL DASHBOARD) =====

class _ProfileBottomNavBar extends StatefulWidget {
  final String userName;

  const _ProfileBottomNavBar({required this.userName});

  @override
  State<_ProfileBottomNavBar> createState() => _ProfileBottomNavBarState();
}

class _ProfileBottomNavBarState extends State<_ProfileBottomNavBar> {
  int _selectedIndex = 3; // Perfil seleccionado

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardScreen(userName: widget.userName),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AmenitiesScreen(userName: widget.userName),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
        );
        break;
      case 3:
        // Ya estamos en el perfil
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
