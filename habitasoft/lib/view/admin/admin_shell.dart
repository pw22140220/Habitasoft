import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin_state.dart';
import 'admin_dashboard_screen.dart';
import 'admin_alerts_screen.dart';
import 'admin_incidents_screen.dart';
import 'admin_profile_screen.dart';
import 'admin_historial_screen.dart';
import '../../providers/incidente_provider.dart';

class AdminShell extends StatefulWidget {
  final String? accessToken;

  const AdminShell({super.key, this.accessToken});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;
  int _incidentKey = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.accessToken != null && mounted) {
        final adminState = Provider.of<AdminState>(context, listen: false);
        adminState.setToken(widget.accessToken!);
        adminState.init();
        final incidenteProvider = Provider.of<IncidenteProvider>(
          context,
          listen: false,
        );
        incidenteProvider.setToken(widget.accessToken);
      }
    });
  }

  List<Widget> get _screens => [
    const AdminDashboardScreen(),
    const AdminAlertsScreen(),
    AdminIncidentsScreen(key: ValueKey('incidents_$_incidentKey')),
    const AdminHistorialScreen(),
    const AdminProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 4) {
        _incidentKey++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Incidentes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class NoCondominiumSelected extends StatelessWidget {
  const NoCondominiumSelected({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apartment, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            'Selecciona un condominio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Para continuar, selecciona un condominio desde el Inicio',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
