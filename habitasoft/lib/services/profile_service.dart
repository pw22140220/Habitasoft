import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProfile {
  final int id;
  final String nombre;
  final String email;
  final String? telefono;
  final String rol;
  final String? fechaCreacion;

  UserProfile({
    required this.id,
    required this.nombre,
    required this.email,
    this.telefono,
    required this.rol,
    this.fechaCreacion,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      telefono: json['telefono'] as String?,
      rol: json['rol'] as String,
      fechaCreacion: json['fechaCreacion'] as String?,
    );
  }

  String get rolTexto {
    switch (rol) {
      case 'administrador':
        return 'Administrador';
      case 'residente':
        return 'Residente';
      case 'guardia':
        return 'Guardia de Seguridad';
      default:
        return rol;
    }
  }
}

class ProfileService {
  static const String _baseUrl = 'http://10.0.2.2:8084';

  final String? _token;

  ProfileService({String? token}) : _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<UserProfile> getPerfil() async {
    final url = Uri.parse('$_baseUrl/api/usuario/perfil');
    final response = await http
        .get(url, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener perfil: ${response.statusCode}');
    }
  }

  Future<UserProfile> actualizarPerfil(
    String nombre,
    String email,
    String? telefono,
  ) async {
    final url = Uri.parse('$_baseUrl/api/usuario/perfil');
    final body = <String, dynamic>{'nombre': nombre, 'email': email};
    if (telefono != null) body['telefono'] = telefono;

    final response = await http
        .put(url, headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      final msg = _extractError(response.body);
      throw Exception(msg);
    }
  }

  Future<void> cambiarPassword(
    String passwordActual,
    String passwordNueva,
    String confirmarPasswordNueva,
  ) async {
    final url = Uri.parse('$_baseUrl/api/usuario/cambiar-password');
    final body = {
      'passwordActual': passwordActual,
      'passwordNueva': passwordNueva,
      'confirmarPasswordNueva': confirmarPasswordNueva,
    };

    final response = await http
        .put(url, headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      final msg = _extractError(response.body);
      throw Exception(msg);
    }
  }

  String _extractError(String body) {
    try {
      final json = jsonDecode(body);
      if (json is Map && json.containsKey('message')) {
        return json['message'] as String;
      }
    } catch (_) {}
    return 'Error en la operación';
  }
}
