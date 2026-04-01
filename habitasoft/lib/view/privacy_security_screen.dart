import 'package:flutter/material.dart';
import 'legal_document_screen.dart';

// Pantalla de Privacidad y Seguridad - Con funcionalidades
class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _useBiometric = false;

  // Texto para Política de Privacidad
  static const String privacyPolicyText = '''
En Habitasoft, tu privacidad y la seguridad de tus datos son nuestra máxima prioridad.

1. Recopilación de Datos:
Recopilamos información básica exclusivamente para la gestión de accesos y comunicación del condominio.

2. Uso de la Información:
Tu información se utiliza para generar códigos QR, gestionar reservas y enviarte notificaciones.

3. Protección:
No compartimos tu información personal con terceros.

4. Datos Biométricos:
Si usas Face ID o Huella digital, esos datos permanecen encriptados en tu dispositivo. Habitasoft no tiene acceso a ellos.
''';

  // Texto para Términos y Condiciones
  static const String termsConditionsText = '''
Al utilizar Habitasoft, aceptas lo siguiente:

1. Uso de la Cuenta:
Tu cuenta es personal. Eres responsable de los accesos generados (Códigos QR).

2. Amenidades:
El uso de áreas comunes está sujeto al reglamento del condominio.

3. Pagos:
La sección de pagos es informativa. Aclaraciones deben tratarse con la administración.

4. Suspensión:
La administración puede suspender el acceso a la app por incumplimiento del reglamento o adeudos.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacidad y Seguridad'),
        backgroundColor: const Color(0xFF0A896E),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card informativo
          Card(
            elevation: 0,
            color: const Color(0xFFE8F5E9), // Verde muy claro
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.security,
                    size: 40,
                    color: const Color(0xFF0A896E),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tu privacidad es nuestra prioridad',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Habitasoft protege tus datos y nunca los comparte con terceros.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Lista de opciones
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.fingerprint,
                    color: Color(0xFF555555),
                  ),
                  title: const Text(
                    'Inicio de sesión con Huella/Face ID',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: Switch(
                    value: _useBiometric,
                    activeColor: const Color(0xFF0B64D8),
                    onChanged: (value) {
                      setState(() => _useBiometric = value);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value
                                ? 'Autenticación biométrica activada'
                                : 'Autenticación biométrica desactivada',
                          ),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(
                    Icons.privacy_tip_outlined,
                    color: Color(0xFF555555),
                  ),
                  title: const Text(
                    'Política de Privacidad',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => LegalDocumentScreen(
                              title: 'Política de Privacidad',
                              content: privacyPolicyText,
                            ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(
                    Icons.description_outlined,
                    color: Color(0xFF555555),
                  ),
                  title: const Text(
                    'Términos y Condiciones',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => LegalDocumentScreen(
                              title: 'Términos y Condiciones',
                              content: termsConditionsText,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
