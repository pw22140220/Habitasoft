import 'package:flutter/material.dart';
import 'dashboard.dart';
import '../services/biometric_service.dart';

// Pantalla de Login con opción de autenticación biométrica
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final BiometricService _biometricService = BiometricService();
  bool _isLoading = false;

  // Función para mostrar el BottomSheet de biometría
  Future<void> _showBiometricBottomSheet() async {
    final isAvailable = await _biometricService.isBiometricAvailable();

    if (!isAvailable) {
      // Si no hay biometría disponible, ir directo al dashboard
      _navigateToDashboard();
      return;
    }

    // Verificar que el contexto esté disponible
    if (!mounted) return;

    // Mostrar BottomSheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBiometricBottomSheet(),
    );
  }

  // Construir el BottomSheet de biometría
  Widget _buildBiometricBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ícono de huella
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7FF),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.fingerprint,
              size: 48,
              color: Color(0xFF0B64D8),
            ),
          ),
          const SizedBox(height: 20),

          // Título
          const Text(
            'Inicio de sesión más rápido',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),

          // Subtítulo
          const Text(
            '¿Deseas usar tu huella digital o Face ID la próxima vez?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.4),
          ),
          const SizedBox(height: 32),

          // Botón Activar
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _activateBiometric,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B64D8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Activar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Botón Quizás más tarde
          SizedBox(
            width: double.infinity,
            height: 52,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                _navigateToDashboard();
              },
              child: const Text(
                'Quizás más tarde',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF555555),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // Activar autenticación biométrica
  Future<void> _activateBiometric() async {
    setState(() => _isLoading = true);

    try {
      final authenticated = await _biometricService.authenticate();

      if (!mounted) return;

      if (authenticated) {
        Navigator.pop(context); // Cerrar BottomSheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Autenticación biométrica activada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        _navigateToDashboard();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Autenticación fallida. Intenta de nuevo.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Navegar al Dashboard
  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardScreen(userName: 'Usuario'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A896E), Color(0xFF00715D), Color(0xFF005E4E)],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/habitasoft_logo.png',
                  height: 125,
                  width: 125,
                ),
                const SizedBox(height: 16),

                // Título
                const Text(
                  'HABITASOFT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.5,
                  ),
                ),
                const SizedBox(height: 4),

                // Subtítulo
                const Text(
                  'CONDOMINIUM MANAGEMENT',
                  style: TextStyle(
                    color: Colors.white70,
                    letterSpacing: 1.5,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 60),

                // Botón de Iniciar Sesión
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _showBiometricBottomSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFBFEF5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF005E4E),
                              ),
                            )
                            : const Text(
                              'INICIAR SESIÓN',
                              style: TextStyle(
                                color: Color(0xFF005E4E),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
