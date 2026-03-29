import 'package:flutter/material.dart';
import 'package:habitasoft/view/profile_screen.dart';
import 'amenities_screen.dart';
import 'notifications_screen.dart';

// ====== AJUSTES ======
const double kCardsOverlap = 33;
const double kBlueExtraHeight = 60;
// =====================

class DashboardScreen extends StatelessWidget {
  final String userName;

  const DashboardScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      bottomNavigationBar: _BottomNavBar(userName: userName),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _Header(userName: userName),
              Transform.translate(
                offset: const Offset(0, -kCardsOverlap),
                child: _OptionsGrid(userName: userName),
              ),
              const SizedBox(height: kCardsOverlap),
              const _CommunitySection(),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== HEADER AZUL ==================

class _Header extends StatelessWidget {
  final String userName;

  const _Header({required this.userName});

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF15806C);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: kBlueExtraHeight,
      ),
      decoration: const BoxDecoration(
        color: blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FILA SUPERIOR: "Dashboard" + campana
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),

              // --- CAMBIO AQUÍ: Agregamos GestureDetector para detectar el click ---
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.notifications_none, color: blue),
                ),
              ),
              // -------------------------------------------------------------------
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome Home,\n$userName!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ================== GRID DE OPCIONES ==================
// (Sin cambios, solo oculto para ahorrar espacio visual en la respuesta)
class _OptionsGrid extends StatelessWidget {
  final String userName;
  const _OptionsGrid({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.2,
        children: [
          _DashboardCard(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Pay Dues',
            onTap: () {
              // Navegar a pagos
            },
          ),
          _DashboardCard(
            icon: Icons.event_note_outlined,
            label: 'Book Amenities',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AmenitiesScreen(userName: userName),
                ),
              );
            },
          ),
          _DashboardCard(
            icon: Icons.build_outlined,
            label: 'Service Requests',
            onTap: () {
              // Navegar a servicios
            },
          ),
          _DashboardCard(
            icon: Icons.forum_outlined,
            label: 'Community Feed',
            onTap: () {
              // Navegar a feed
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
  final VoidCallback onTap;
  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0B64D8);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: blue),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== COMMUNITY FEED ==================
// (Sin cambios significativos)
class _CommunitySection extends StatelessWidget {
  const _CommunitySection();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Community Feed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: _FeedCard(),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}

class _FeedCard extends StatelessWidget {
  const _FeedCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFEBF0FF),
                child: Icon(Icons.apartment, color: Color(0xFF0B64D8)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Community',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '1 hour ago',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, size: 20, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Welcome to the condominium management app! 😊',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ================== BOTTOM NAVIGATION BAR ==================

class _BottomNavBar extends StatelessWidget {
  final String userName;

  const _BottomNavBar({required this.userName});

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0B64D8);

    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AmenitiesScreen(userName: userName),
            ),
          );
        } else if (index == 2) {
          // --- CAMBIO AQUÍ: Lógica para el botón "Alerts" ---
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          );
          // --------------------------------------------------
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileScreen(userName: userName),
            ),
          );
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: blue,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Amenities',
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
