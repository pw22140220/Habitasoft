import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'profile_screen.dart';

// ===== AZUL PRINCIPAL (MISMO QUE DASHBOARD/PROFILE) =====
// Si quieres cambiar el color del header, SOLO modifica esta línea:
const kPrimaryBlue = Color(0xFF0B64D8);
// =======================================================

class AmenitiesScreen extends StatefulWidget {
  final String userName; // 👈 nombre del usuario logueado

  const AmenitiesScreen({super.key, required this.userName});

  @override
  State<AmenitiesScreen> createState() => _AmenitiesScreenState();
}

class _AmenitiesScreenState extends State<AmenitiesScreen> {
  int _selectedDay = 23; // día seleccionado visualmente (23 como en la imagen)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      // pasamos userName al bottom nav
      bottomNavigationBar: _AmenitiesBottomNavBar(userName: widget.userName),
      body: SafeArea(
        child: Column(
          children: [
            const _AmenitiesHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _CalendarSection(
                      selectedDay: _selectedDay,
                      onDayTap: (day) {
                        setState(() => _selectedDay = day);
                      },
                    ),
                    const SizedBox(height: 16),
                    const _BookableSlotsSection(),
                    const SizedBox(height: 16),
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

// ================== HEADER AZUL ==================

class _AmenitiesHeader extends StatelessWidget {
  const _AmenitiesHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 18),
      decoration: const BoxDecoration(
        color: kPrimaryBlue,
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
            'Amenities',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ================== SECCIÓN CALENDARIO ==================

class _CalendarSection extends StatelessWidget {
  final int selectedDay;
  final ValueChanged<int> onDayTap;

  const _CalendarSection({required this.selectedDay, required this.onDayTap});

  @override
  Widget build(BuildContext context) {
    final days = List.generate(31, (index) => index + 1);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Fila mes + flechas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.chevron_left, color: Colors.grey),
              Text(
                'January 2023',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),

          // Días de la semana
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _WeekdayLabel('Sun'),
              _WeekdayLabel('Mon'),
              _WeekdayLabel('Tue'),
              _WeekdayLabel('Wed'),
              _WeekdayLabel('Thu'),
              _WeekdayLabel('Fri'),
              _WeekdayLabel('Sat'),
            ],
          ),
          const SizedBox(height: 8),

          // Grid de días
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = day == selectedDay;

              return GestureDetector(
                onTap: () => onDayTap(day),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimaryBlue : const Color(0xFFE7EDF9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
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

class _WeekdayLabel extends StatelessWidget {
  final String label;

  const _WeekdayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

// ================== SECCIÓN BOOKABLE SLOTS ==================

class _BookableSlotsSection extends StatelessWidget {
  const _BookableSlotsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Título + "Show All"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Bookable slots',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Show All',
                  style: TextStyle(
                    fontSize: 13,
                    color: kPrimaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          const _SlotCard(
            icon: Icons.home_outlined,
            title: 'Clubhouse',
            timeRange: '7:00 am - 5:00 am',
          ),
          const _SlotCard(
            icon: Icons.pool_outlined,
            title: 'Swimming Pool',
            timeRange: '8:00 am - 8:00 pm',
          ),
        ],
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String timeRange;

  const _SlotCard({
    required this.icon,
    required this.title,
    required this.timeRange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE7EDF9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: kPrimaryBlue),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(
                timeRange,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================== BOTTOM NAVIGATION BAR ==================

class _AmenitiesBottomNavBar extends StatelessWidget {
  final String userName;

  const _AmenitiesBottomNavBar({required this.userName});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1, // 0 home, 1 calendario (amenities), 2 bell, 3 perfil
      onTap: (index) {
        if (index == 0) {
          // Home → Dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DashboardScreen(userName: userName),
            ),
          );
        } else if (index == 3) {
          // Perfil
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileScreen(userName: userName),
            ),
          );
        }
        // (1 y 2) por ahora no hacen nada especial
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kPrimaryBlue,
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
