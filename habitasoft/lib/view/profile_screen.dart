import 'package:flutter/material.dart';
import 'dashboard.dart'; // está en el mismo folder lib/view/

// ==== AZUL PRINCIPAL (MISMO QUE DASHBOARD) ====
// Si quieres cambiar el color del header, SOLO modifica esta línea:
const kPrimaryBlue = Color(0xFF0A896E);
// =============================================

class ProfileScreen extends StatefulWidget {
  final String userName; // 👈 nombre del usuario logueado

  const ProfileScreen({super.key, required this.userName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifPrefs = true;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      // pasamos el nombre al bottom nav
      bottomNavigationBar: _ProfileBottomNavBar(userName: widget.userName),
      body: SafeArea(
        child: Column(
          children: [
            const _ProfileHeader(),
            const SizedBox(height: 40), // espacio para el avatar
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // ===== BLOQUE SUPERIOR: User Settings / Notifications =====
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: const [
                        _SettingsTile(
                          icon: Icons.settings_outlined,
                          label: 'User Settings',
                        ),
                        Divider(height: 1),
                        _SettingsTile(
                          icon: Icons.tune_outlined,
                          label: 'Notifications',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Notifications',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),

                  // ===== BLOQUE NOTIFICATIONS (switches) =====
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.notifications_none),
                          title: const Text('Notification Preferences'),
                          trailing: Switch(
                            value: _notifPrefs,
                            activeColor: kPrimaryBlue,
                            onChanged: (value) {
                              setState(() => _notifPrefs = value);
                            },
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.chat_bubble_outline),
                          title: const Text('Notifications - 13'),
                          trailing: Switch(
                            value: _notifications,
                            activeColor: kPrimaryBlue,
                            onChanged: (value) {
                              setState(() => _notifications = value);
                            },
                          ),
                        ),
                        const Divider(height: 1),
                        const ListTile(
                          leading: Icon(Icons.help_outline),
                          title: Text('Help & Support'),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== HEADER AZUL + AVATAR =====

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: const BoxDecoration(
              color: kPrimaryBlue, // 👈 usa el azul global
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Positioned(
            left: 20,
            bottom: -32,
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFFE0E5F2),
                child: Icon(
                  Icons.person,
                  color: kPrimaryBlue, // 👈 también usa el mismo azul
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== TILE REUTILIZABLE PARA User Settings / Notifications =====

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SettingsTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

// ===== BOTTOM NAV BAR (igual al dashboard, perfil seleccionado) =====

class _ProfileBottomNavBar extends StatelessWidget {
  final String userName;

  const _ProfileBottomNavBar({required this.userName});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 3, // 0: Home, 1: grid, 2: bell, 3: profile
      onTap: (index) {
        if (index == 0) {
          // Home → volvemos al Dashboard y le pasamos el nombre
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DashboardScreen(userName: userName),
            ),
          );
        }
        // (1,2,3) por ahora no hacen nada
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kPrimaryBlue,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: 'Alerts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
