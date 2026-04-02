import 'package:flutter/material.dart';

class AdminResidentsScreen extends StatelessWidget {
  const AdminResidentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Residentes'),
        backgroundColor: Colors.green[700],
        elevation: 2,
      ),
      body: const Center(child: Text('Pantalla de Residentes')),
    );
  }
}
