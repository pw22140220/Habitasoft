import 'package:flutter/material.dart';

class AdminPaymentsScreen extends StatelessWidget {
  const AdminPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordatorios de Pago'),
        backgroundColor: Colors.green[700],
        elevation: 2,
      ),
      body: const Center(child: Text('Pantalla de Recordatorios de Pago')),
    );
  }
}
