import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dashboard.dart';
import 'profile_screen.dart';
import 'residente_reservaciones_screen.dart';
import '../../models/amenidad_model.dart';
import '../../models/reservacion_model.dart';
import '../../services/amenidad_service.dart';
import '../../services/reservacion_service.dart';
import '../../services/auth_service.dart';

const Color kPrimaryGreen = Color(0xFF15806C);
const Color kPrimaryBlue = Color(0xFF0B64D8);
const Color kLightGray = Color(0xFFF5F6FA);
const Color kCardShadow = Color(0x0A000000);

class AmenitiesScreen extends StatefulWidget {
  final String userName;
  final String? token;

  const AmenitiesScreen({super.key, required this.userName, this.token});

  @override
  State<AmenitiesScreen> createState() => _AmenitiesScreenState();
}

class _AmenitiesScreenState extends State<AmenitiesScreen> {
  List<Amenidad> _amenidades = [];
  bool _isLoading = false;
  String? _error;
  int _condominioId = 1;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  AmenidadService get _amenidadService => AmenidadService(token: widget.token);
  ReservacionService get _reservacionService =>
      ReservacionService(token: widget.token);

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _condominioId = await AuthService.obtenerCondominioId(widget.token);
    _cargarAmenidades();
  }

  Future<void> _cargarAmenidades() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final amenities = await _amenidadService.listarResidente(_condominioId);
      setState(() => _amenidades = amenities);
    } catch (e) {
      setState(() => _error = 'Error al cargar amenidades');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _reservarAmenidad(Amenidad amenidad) async {
    final fecha = _selectedDay;
    final fechaStr =
        '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';

    final horario = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => _HorarioPickerDialog(fecha: fechaStr),
    );
    if (horario == null) return;

    try {
      await _reservacionService.crear(
        amenidad.id,
        horario['inicio']!,
        horario['fin']!,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${amenidad.nombre} reservada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGray,
      bottomNavigationBar: _AmenitiesBottomNavBar(
        userName: widget.userName,
        token: widget.token,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _AmenitiesHeader(
                userName: widget.userName,
                onMisReservaciones: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ResidenteReservacionesScreen(
                            userName: widget.userName,
                            token: widget.token,
                          ),
                    ),
                  );
                },
              ),
              Transform.translate(
                offset: const Offset(0, -33),
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
                    setState(() => _calendarFormat = format);
                  },
                  onPageChanged: (focusedDay) {
                    setState(() => _focusedDay = focusedDay);
                  },
                ),
              ),
              const SizedBox(height: 33),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Amenidades Disponibles',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ResidenteReservacionesScreen(
                                  userName: widget.userName,
                                  token: widget.token,
                                ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.list_alt, size: 18),
                      label: const Text('Mis reservas'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _isLoading
                  ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  )
                  : _error != null
                  ? Center(
                    child: Column(
                      children: [
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _cargarAmenidades,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                  : _amenidades.isEmpty
                  ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: Text(
                      'No hay amenidades disponibles',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _amenidades.length,
                    itemBuilder:
                        (ctx, i) => _AmenidadCard(
                          amenidad: _amenidades[i],
                          onReservar: () => _reservarAmenidad(_amenidades[i]),
                        ),
                  ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _HorarioPickerDialog extends StatefulWidget {
  final String fecha;
  const _HorarioPickerDialog({required this.fecha});

  @override
  State<_HorarioPickerDialog> createState() => _HorarioPickerDialogState();
}

class _HorarioPickerDialogState extends State<_HorarioPickerDialog> {
  TimeOfDay _horaInicio = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _horaFin = const TimeOfDay(hour: 10, minute: 0);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccionar horario'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Fecha: ${widget.fecha}'),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text('Inicio: ${_horaInicio.format(context)}'),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _horaInicio,
              );
              if (picked != null) setState(() => _horaInicio = picked);
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text('Fin: ${_horaFin.format(context)}'),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _horaFin,
              );
              if (picked != null) setState(() => _horaFin = picked);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final inicio =
                '${widget.fecha}T${_horaInicio.hour.toString().padLeft(2, '0')}:${_horaInicio.minute.toString().padLeft(2, '0')}:00';
            final fin =
                '${widget.fecha}T${_horaFin.hour.toString().padLeft(2, '0')}:${_horaFin.minute.toString().padLeft(2, '0')}:00';
            Navigator.pop(context, {'inicio': inicio, 'fin': fin});
          },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}

class _AmenitiesHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onMisReservaciones;

  const _AmenitiesHeader({
    required this.userName,
    required this.onMisReservaciones,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 60),
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
                onTap: onMisReservaciones,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.list_alt, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Mis reservas',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
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
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: kPrimaryBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: kPrimaryBlue,
            fontWeight: FontWeight.w600,
          ),
          selectedDecoration: const BoxDecoration(
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
        daysOfWeekHeight: 24,
        rowHeight: 40,
      ),
    );
  }
}

class _AmenidadCard extends StatelessWidget {
  final Amenidad amenidad;
  final VoidCallback onReservar;

  const _AmenidadCard({required this.amenidad, required this.onReservar});

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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: kPrimaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.place_outlined,
              size: 28,
              color: kPrimaryBlue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amenidad.nombre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amenidad.capacidadMaxima != null
                      ? 'Capacidad máxima: ${amenidad.capacidadMaxima} personas'
                      : 'Sin límite de capacidad',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onReservar,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Reservar',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenitiesBottomNavBar extends StatefulWidget {
  final String userName;
  final String? token;

  const _AmenitiesBottomNavBar({required this.userName, this.token});

  @override
  State<_AmenitiesBottomNavBar> createState() => _AmenitiesBottomNavBarState();
}

class _AmenitiesBottomNavBarState extends State<_AmenitiesBottomNavBar> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => DashboardScreen(
                  userName: widget.userName,
                  token: widget.token,
                ),
          ),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const _PlaceholderScreen(label: 'Alertas'),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
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

class _PlaceholderScreen extends StatelessWidget {
  final String label;
  const _PlaceholderScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: const Center(child: Text('Pantalla en construcción')),
    );
  }
}
