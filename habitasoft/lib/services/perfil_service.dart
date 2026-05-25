import 'dart:convert';
import 'package:http/http.dart' as http;

class UsuarioPerfil {
  final int id;
  final String nombre;
  final String email;
  final String? telefono;
  final String? rol;
  final String? numeroUnidad;
  final String? fechaCreacion;

  UsuarioPerfil({
    required this.id,
    required this.nombre,
    required this.email,
    this.telefono,
    this.rol,
    this.numeroUnidad,
    this.fechaCreacion,
  });

  factory UsuarioPerfil.fromJson(Map<String, dynamic> json) {
    return UsuarioPerfil(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      telefono: json['telefono'] as String?,
      rol: json['rol'] as String?,
      numeroUnidad: json['numeroUnidad'] as String?,
      fechaCreacion: json['fechaCreacion'] as String?,
    );
  }
}

class PerfilService {
  static const String _baseUrl = 'http://10.0.2.2:8084';

  final String? _token;

  PerfilService({String? token}) : _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<UsuarioPerfil> obtenerPerfil() async {
    final uri = Uri.parse('$_baseUrl/api/usuario/perfil');
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return UsuarioPerfil.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al obtener perfil: ${response.statusCode}');
  }

  Future<UsuarioPerfil> actualizarPerfil({
    required String nombre,
    required String email,
    String? telefono,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/usuario/perfil');
    final body = {
      'nombre': nombre,
      'email': email,
      if (telefono != null) 'telefono': telefono,
    };

    final response = await http
        .put(uri, headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return UsuarioPerfil.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al actualizar perfil: ${response.statusCode}');
  }

  Future<void> cambiarPassword({
    required String passwordActual,
    required String passwordNueva,
    required String confirmarPasswordNueva,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/usuario/cambiar-password');
    final body = {
      'passwordActual': passwordActual,
      'passwordNueva': passwordNueva,
      'confirmarPasswordNueva': confirmarPasswordNueva,
    };

    final response = await http
        .put(uri, headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return;
    }
    final msg = _extractError(response.body);
    throw Exception(msg);
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
