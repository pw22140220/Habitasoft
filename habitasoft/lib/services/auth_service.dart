import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

// Modelo para la respuesta de login
class LoginResponse {
  final String userName;
  final String userRole; // 'admin', 'resident', 'guard'

  LoginResponse({required this.userName, required this.userRole});
}

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:8084';

  // Devuelve LoginResponse con nombre y rol del usuario
  Future<LoginResponse> login(String email, String password) async {
    // Validación básica local
    if (email.isEmpty || password.isEmpty) {
      throw AuthException('El correo y la contraseña son obligatorios.');
    }

    if (!email.contains('@')) {
      throw AuthException('Correo inválido.');
    }

    try {
      final url = Uri.parse('$_baseUrl/auth/login');

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('STATUS: ${response.statusCode}');
        print('LOGIN BODY: ${response.body}');
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final usuario = data['usuario'] as Map<String, dynamic>;
        final userName = usuario['nombre'] as String;
        // Por defecto, asumimos rol de residente si no viene en la respuesta
        final userRole = usuario['rol'] as String? ?? 'admin';

        return LoginResponse(userName: userName, userRole: userRole);
      } else if (response.statusCode == 400) {
        throw AuthException(
          'Datos inválidos. Verifica el correo y la contraseña.',
        );
      } else if (response.statusCode == 401) {
        throw AuthException('Correo o contraseña incorrectos.');
      } else {
        throw AuthException('Error en el servidor (${response.statusCode}).');
      }
    } on http.ClientException catch (e) {
      // Si falla la conexión, usar datos mock para desarrollo
      print('Error de conexión: $e');
      print('Usando datos mock para desarrollo...');

      // Datos mock para desarrollo
      if (email == 'admin@habitasoft.com' && password == 'admin123') {
        return LoginResponse(userName: 'Administrador', userRole: 'admin');
      } else if (email == 'usuario@condominio.com' &&
          password == 'usuario123') {
        return LoginResponse(userName: 'Juan Pérez', userRole: 'resident');
      } else {
        throw AuthException('Correo o contraseña incorrectos (modo mock).');
      }
    } on Exception catch (e) {
      throw AuthException('Error inesperado: $e');
    }
  }
}
