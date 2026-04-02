import 'package:flutter/material.dart';

class AdminAnnouncementsScreen extends StatelessWidget {
  const AdminAnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anuncios'),
        backgroundColor: Colors.green[700],
        elevation: 2,
      ),
      body: const Center(child: Text('Pantalla de Anuncios')),
    );
  }
}
