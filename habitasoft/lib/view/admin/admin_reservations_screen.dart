import 'package:flutter/material.dart';

class AdminReservationsScreen extends StatelessWidget {
  const AdminReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas'),
        backgroundColor: Colors.green[700],
        elevation: 2,
      ),
      body: const Center(child: Text('Pantalla de Reservas')),
    );
  }
}
