import 'package:flutter/material.dart';
import 'dashboard.dart';
import '../services/auth_service.dart'; // ajusta la ruta según tu estructura

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
      // AHORA login devuelve el nombre del usuario
      final userName = await _authService.login(
        _emailCtrl.text.trim(),
        _passwordCtrl.text,
      );

      if (!mounted) return;

      // 2) Si el backend respondió 200, navegamos al dashboard con el nombre
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(userName: userName),
        ),
      );
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
              key: _formKey, // aquí usamos el form
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: topPad),

                  //  LOGO
                  Image.asset(
                    'assets/images/habitasoft_logo.png',
                    height: 125,
                    width: 125,
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
