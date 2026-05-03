import 'package:flutter/material.dart';
import '../resident/dashboard.dart';
import '../admin/admin_shell.dart';
import '../watchman/watchman_dashboard.dart';
import '../../services/auth_service.dart';
import '../../services/biometric_service.dart';
import '../../services/biometric_preferences_service.dart';
import 'biometric_prompt_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _obscure = true;

  // controladores para leer email y password
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  // key para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // servicio de auth
  final _authService = AuthService();
  final _biometricService = BiometricService();

  bool _isLoading = false;

  // 🎨 Paleta final exacta (no se toca)
  static const Color topGreen = Color(0xFF0A896E); // claro (arriba)
  static const Color midGreen = Color(0xFF00715D); // intermedio
  static const Color bottomGreen = Color(0xFF005E4E); // oscuro (abajo)
  static const Color fieldGreen = Color(0xFF15806C); // pills
  static const Color buttonCream = Color(0xFFFBFEF5); // botón
  static const Color buttonText = Color(0xFF005E4E); // texto botón

  // 📏 Espaciados con getters
  double get topPad => 70;
  double get gapAfterSubtitle => 20;
  double get gapBetweenFields => 15;
  double get gapBeforeButton => 18;
  double get gapAfterButton => 14;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    // 1) Validación local (campos vacíos / formato)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Login con el backend (manteniendo la lógica original)
      final loginResponse = await _authService.login(
        _emailCtrl.text.trim(),
        _passwordCtrl.text,
      );

      if (!mounted) return;

      // Guardar el nombre del usuario en shared_preferences
      await BiometricPreferencesService.setUserName(loginResponse.userName);

      // Verificar si la biometría está activada
      final biometricEnabled =
          await BiometricPreferencesService.getBiometricEnabled();

      print('DEBUG: biometricEnabled = $biometricEnabled');

      // Verificar si el dispositivo soporta biometría
      final isBiometricAvailable =
          await _biometricService.isBiometricAvailable();
      print('DEBUG: isBiometricAvailable = $isBiometricAvailable');

      if (biometricEnabled && isBiometricAvailable) {
        // Biometría activada y disponible: intentar autenticación biométrica
        print('DEBUG: Intentando autenticación biométrica directa');
        await _handleBiometricLogin(loginResponse);
      } else if (isBiometricAvailable) {
        // Biometría disponible pero no activada: mostrar modal de activación
        print('DEBUG: Mostrando modal de activación de biometría');
        await _showBiometricPrompt(loginResponse);
      } else {
        // Biometría no disponible: navegar directo al dashboard
        print('DEBUG: Biometría no disponible, navegando directo');
        _navigateToDashboard(loginResponse);
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error inesperado. Intenta de nuevo.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Manejar login biométrico (cuando ya está activado)
  Future<void> _handleBiometricLogin(LoginResponse loginResponse) async {
    try {
      final authenticated = await _biometricService.authenticate();

      if (!mounted) return;

      if (authenticated) {
        // Autenticación biométrica exitosa
        print('DEBUG: Autenticación biométrica exitosa');
        _navigateToDashboard(loginResponse);
      } else {
        // Falló la autenticación biométrica - ofrecer alternativa
        print('DEBUG: Autenticación biométrica fallida');
        if (!mounted) return;

        final choice = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Autenticación fallida'),
                content: const Text(
                  'No se pudo verificar tu huella digital. ¿Deseas intentar de nuevo o continuar sin biometría?',
                ),
                actions: [
                  TextButton(
                    onPressed:
                        () => Navigator.pop(context, true), // Intentar de nuevo
                    child: const Text('Intentar de nuevo'),
                  ),
                  TextButton(
                    onPressed:
                        () => Navigator.pop(
                          context,
                          false,
                        ), // Continuar sin biometría
                    child: const Text('Continuar sin biometría'),
                  ),
                ],
              ),
        );

        if (choice == true) {
          // Intentar de nuevo
          await _handleBiometricLogin(loginResponse);
        } else if (choice == false) {
          // Continuar sin biometría
          _navigateToDashboard(loginResponse);
        }
      }
    } catch (e) {
      print('DEBUG: Error en autenticación biométrica: $e');
      if (!mounted) return;

      // Si hay error, continuar sin biometría
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error en autenticación biométrica. Continuando sin biometría.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      _navigateToDashboard(loginResponse);
    }
  }

  // Mostrar modal de activación de biometría
  Future<void> _showBiometricPrompt(LoginResponse loginResponse) async {
    print('DEBUG: Mostrando modal de activación de biometría');

    // Mostrar modal de activación
    final result = await BiometricPromptSheet.show(
      context: context,
      onActivateBiometric: () async {
        if (!mounted) return;
        print('DEBUG: Usuario presionó "Activar huella digital"');

        try {
          final authenticated = await _biometricService.authenticate();

          if (!mounted) return;

          if (authenticated) {
            // Guardar preferencia de biometría activada
            await BiometricPreferencesService.setBiometricEnabled(true);
            print('DEBUG: Biometría activada exitosamente');

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Huella digital activada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
            }

            _navigateToDashboard(loginResponse);
          } else {
            print('DEBUG: Autenticación biométrica fallida');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No se pudo verificar tu huella digital'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          print('DEBUG: Error en activación de biometría: $e');
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al activar biometría: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      onClose: () {
        if (!mounted) return;
        print(
          'DEBUG: Usuario presionó "Cerrar", navegando sin activar biometría',
        );
        _navigateToDashboard(loginResponse); // Navegar sin activar biometría
      },
    );

    // Si el usuario cierra el modal tocando fuera
    if (result == null && mounted) {
      print(
        'DEBUG: Modal cerrado tocando fuera, navegando sin activar biometría',
      );
      _navigateToDashboard(loginResponse);
    }
  }

  // Navegar al Dashboard según el rol
  void _navigateToDashboard(LoginResponse loginResponse) {
    if (loginResponse.userRole == 'admin') {
      // Navegar al AdminShell
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminShell()),
      );
    } else if (loginResponse.userRole == 'guard') {
      // Navegar al Dashboard del vigilante
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  WatchmanDashboardScreen(userName: loginResponse.userName),
        ),
      );
    } else {
      // Navegar al Dashboard normal para residentes
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => DashboardScreen(userName: loginResponse.userName),
        ),
      );
    }
  }

  // Widget placeholder para el logo (si falla la carga)
  Widget _buildLogoPlaceholder() {
    return Container(
      height: 125,
      width: 125,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apartment, size: 60, color: Colors.white),
          SizedBox(height: 8),
          Text(
            'HS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Degradado de arriba (claro) a abajo (oscuro)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [topGreen, midGreen, bottomGreen],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: topPad),

                  // LOGO - Con manejo robusto de errores
                  Builder(
                    builder: (context) {
                      try {
                        return Image.asset(
                          'assets/images/habitasoft_logo.png',
                          height: 125,
                          width: 125,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildLogoPlaceholder();
                          },
                        );
                      } catch (e) {
                        return _buildLogoPlaceholder();
                      }
                    },
                  ),

                  Transform.translate(
                    offset: const Offset(3, -17),
                    child: const Text(
                      'HABITASOFT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ),

                  Transform.translate(
                    offset: const Offset(2, -17),
                    child: const Text(
                      'CONDOMINIUM MANAGEMENT',
                      style: TextStyle(
                        color: Colors.white70,
                        letterSpacing: 1.5,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  SizedBox(height: gapAfterSubtitle),

                  // ✉ EMAIL
                  _InputField(
                    controller: _emailCtrl,
                    hint: 'Email Address',
                    fillColor: fieldGreen.withOpacity(0.75),
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty) {
                        return 'El correo es obligatorio';
                      }
                      if (!v.contains('@')) {
                        return 'Correo inválido';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: gapBetweenFields),

                  // 🔒 PASSWORD
                  _InputField(
                    controller: _passwordCtrl,
                    hint: 'Password',
                    obscureText: _obscure,
                    fillColor: fieldGreen.withOpacity(0.75),
                    suffix: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white70,
                      ),
                    ),
                    validator: (value) {
                      if ((value ?? '').isEmpty) {
                        return 'La contraseña es obligatoria';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: gapBeforeButton),

                  // 🔘 LOG IN
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: buttonCream,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: _isLoading ? null : _onLoginPressed,
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: buttonText,
                                ),
                              )
                              : const Text(
                                'LOG IN',
                                style: TextStyle(
                                  color: buttonText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                    ),
                  ),

                  SizedBox(height: gapAfterButton),

                  const Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.white70),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final Widget? suffix;
  final Color fillColor;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const _InputField({
    required this.hint,
    required this.fillColor,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white70,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffix,
      ),
    );
  }
}
