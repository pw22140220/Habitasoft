import 'package:flutter/material.dart';

// Visor de Documentos Legales - Reutilizable para Política de Privacidad y Términos
class LegalDocumentScreen extends StatelessWidget {
  final String title;
  final String content;

  const LegalDocumentScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF0A896E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Color(0xFF333333),
          ),
        ),
      ),
    );
  }
}
