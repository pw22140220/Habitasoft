import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:8084';

  // AHORA devuelve Future<String> con el nombre del usuario
  Future<String> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final usuario = data['usuario'] as Map<String, dynamic>;
      final userName = usuario['nombre'] as String;

      // Aquí luego puedes guardar tokens si quieres:
      // final accessToken = data['accessToken'];
      // final refreshToken = data['refreshToken'];

      return userName;
    } else if (response.statusCode == 400) {
      throw AuthException(
        'Datos inválidos. Verifica el correo y la contraseña.',
      );
    } else if (response.statusCode == 401) {
      throw AuthException('Correo o contraseña incorrectos.');
    } else {
      throw AuthException('Error en el servidor (${response.statusCode}).');
    }
  }
}
