import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dashboard.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';

// ====== CONSTANTES DE DISEÑO (MISMO QUE DASHBOARD) ======
const double kCardsOverlap = 33;
const double kBlueExtraHeight = 60;
const Color kPrimaryGreen = Color(0xFF15806C);
const Color kPrimaryBlue = Color(0xFF0B64D8);
const Color kLightGray = Color(0xFFF5F6FA);
const Color kCardShadow = Color(0x0A000000);
// =======================================================

class AmenitiesScreen extends StatefulWidget {
  final String userName; // 👈 nombre del usuario logueado

  const AmenitiesScreen({super.key, required this.userName});

  @override
  State<AmenitiesScreen> createState() => _AmenitiesScreenState();
}

class _AmenitiesScreenState extends State<AmenitiesScreen> {
  DateTime _selectedDay = DateTime.now(); // Día seleccionado en el calendario
  DateTime _focusedDay = DateTime.now(); // Día enfocado en el calendario
  CalendarFormat _calendarFormat =
      CalendarFormat.month; // Formato del calendario

  // Datos falsos para disponibilidad por día (renta por día completo)
  final Map<DateTime, List<Map<String, dynamic>>> _mockAvailabilityData = {
    DateTime.now(): [
      {
        'id': 1,
        'title': 'Clubhouse',
        'icon': Icons.home_outlined,
        'timeRange': '7:00 am - 5:00 pm',
        'isAvailable': true, // Disponible para renta
      },
      {
        'id': 2,
        'title': 'Swimming Pool',
        'icon': Icons.pool_outlined,
        'timeRange': '8:00 am - 8:00 pm',
        'isAvailable': false, // Ya rentado
      },
    ],
    DateTime.now().add(const Duration(days: 1)): [
      {
        'id': 1,
        'title': 'Clubhouse',
        'icon': Icons.home_outlined,
        'timeRange': '9:00 am - 6:00 pm',
        'isAvailable': false, // Ya rentado
      },
      {
        'id': 2,
        'title': 'Swimming Pool',
        'icon': Icons.pool_outlined,
        'timeRange': '7:00 am - 9:00 pm',
        'isAvailable': true, // Disponible para renta
      },
    ],
    DateTime.now().add(const Duration(days: 2)): [
      {
        'id': 1,
        'title': 'Clubhouse',
        'icon': Icons.home_outlined,
        'timeRange': '8:00 am - 4:00 pm',
        'isAvailable': true, // Disponible para renta
      },
      {
        'id': 2,
        'title': 'Swimming Pool',
        'icon': Icons.pool_outlined,
        'timeRange': '10:00 am - 7:00 pm',
        'isAvailable': true, // Disponible para renta
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    // Obtener disponibilidad para el día seleccionado
    final selectedDateKey = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
    );
    final availabilityForSelectedDay =
        _mockAvailabilityData[selectedDateKey] ??
        _mockAvailabilityData.values.first;

    return Scaffold(
      backgroundColor: kLightGray,
      bottomNavigationBar: _AmenitiesBottomNavBar(userName: widget.userName),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _AmenitiesHeader(userName: widget.userName),
              Transform.translate(
                offset: const Offset(0, -kCardsOverlap),
                child: _CalendarSection(
                  selectedDay: _selectedDay,
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                ),
              ),
              const SizedBox(height: kCardsOverlap),
              _BookableSlotsSection(availability: availabilityForSelectedDay),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== HEADER MODERNO (ESTILO DASHBOARD) ==================

class _AmenitiesHeader extends StatelessWidget {
  final String userName;

  const _AmenitiesHeader({required this.userName});

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
        color: kPrimaryBlue,
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
          // FILA SUPERIOR: Botón atrás + Notificaciones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
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
                    color: kPrimaryBlue,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Reservar Amenidades,\n$userName!',
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
            'Selecciona una fecha y horario disponible',
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

// ================== SECCIÓN CALENDARIO INTERACTIVO ==================

class _CalendarSection extends StatelessWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(CalendarFormat) onFormatChanged;
  final Function(DateTime) onPageChanged;

  const _CalendarSection({
    required this.selectedDay,
    required this.focusedDay,
    required this.calendarFormat,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
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
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        onFormatChanged: onFormatChanged,
        onPageChanged: onPageChanged,
        calendarFormat: calendarFormat,

        // Estilo del encabezado
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.grey),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.grey),
          headerPadding: EdgeInsets.only(bottom: 12),
        ),

        // Estilo de los días de la semana
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          weekendStyle: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),

        // Estilo de los días
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: kPrimaryBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: kPrimaryBlue,
            fontWeight: FontWeight.w600,
          ),
          selectedDecoration: BoxDecoration(
            color: kPrimaryBlue,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          defaultTextStyle: const TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.w400,
          ),
          weekendTextStyle: const TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.w400,
          ),
          outsideDaysVisible: false,
        ),

        // Días de la semana en español
        daysOfWeekHeight: 24,
        rowHeight: 40,
      ),
    );
  }
}

// ================== SECCIÓN BOOKABLE SLOTS ==================

class _BookableSlotsSection extends StatelessWidget {
  final List<Map<String, dynamic>> availability;

  const _BookableSlotsSection({required this.availability});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          const Text(
            'Horarios Disponibles',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Selecciona un horario para reservar',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),

          // Lista de amenidades disponibles
          Column(
            children:
                availability
                    .map(
                      (amenity) => _SlotCard(
                        icon: amenity['icon'] as IconData,
                        title: amenity['title'] as String,
                        timeRange: amenity['timeRange'] as String,
                        isAvailable: amenity['isAvailable'] as bool,
                      ),
                    )
                    .toList(),
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
  final bool isAvailable;

  const _SlotCard({
    required this.icon,
    required this.title,
    required this.timeRange,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
        boxShadow: [
          BoxShadow(
            color: kCardShadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: kPrimaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: kPrimaryBlue),
          ),
          const SizedBox(width: 16),

          // Información - Usando Expanded para evitar overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  timeRange,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Indicador de disponibilidad simplificado
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                      color:
                          isAvailable
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFF9E9E9E),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isAvailable ? 'Disponible' : 'Reservado',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isAvailable
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Botón de reserva
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isAvailable ? kPrimaryBlue : const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isAvailable ? 'Reservar' : 'Ocupado',
              style: TextStyle(
                fontSize: 14,
                color: isAvailable ? Colors.white : const Color(0xFF9E9E9E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================== BOTTOM NAVIGATION BAR MEJORADO ==================

class _AmenitiesBottomNavBar extends StatefulWidget {
  final String userName;

  const _AmenitiesBottomNavBar({required this.userName});

  @override
  State<_AmenitiesBottomNavBar> createState() => _AmenitiesBottomNavBarState();
}

class _AmenitiesBottomNavBarState extends State<_AmenitiesBottomNavBar> {
  int _selectedIndex =
      1; // Calendario seleccionado por defecto en esta pantalla

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Inicio → Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardScreen(userName: widget.userName),
          ),
        );
        break;
      case 1:
        // Ya estamos en Amenities (Calendario)
        break;
      case 2:
        // Alertas → NotificationsScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
        );
        break;
      case 3:
        // Perfil → ProfileScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(userName: widget.userName),
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
