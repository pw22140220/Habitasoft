import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin_state.dart';
import 'admin_dashboard_screen.dart';
import 'admin_condominiums_screen.dart';
import 'admin_alerts_screen.dart';
import 'admin_reservations_screen.dart';
import 'admin_profile_screen.dart';

// Shell principal del administrador con navegación por tabs
class AdminShell extends StatefulWidget {
  final String? accessToken;

  const AdminShell({super.key, this.accessToken});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.accessToken != null && mounted) {
        final adminState = Provider.of<AdminState>(context, listen: false);
        adminState.setToken(widget.accessToken!);
        adminState.init();
      }
    });
  }

  final List<Widget> _screens = [
    const AdminDashboardScreen(),
    const AdminCondominiumsScreen(),
    const AdminReservationsScreen(),
    const AdminAlertsScreen(),
    const AdminProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
            icon: Icon(Icons.apartment),
            label: 'Condominios',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: 'Amenidades'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

// Widget para mostrar cuando no hay condominio seleccionado
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
            'Para continuar, selecciona un condominio de la lista',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Navegar a la pantalla de condominios
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AdminCondominiumsScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text(
              'Seleccionar Condominio',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
