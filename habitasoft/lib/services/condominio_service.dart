import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/condominio_model.dart';

class CondominioService {
  static const String _baseUrl = 'http://10.0.2.2:8084';

  final String? _token;

  CondominioService({String? token}) : _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<List<Condominio>> listar() async {
    final url = Uri.parse('$_baseUrl/api/admin/condominios');
    final response = await http
        .get(url, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'] as List<dynamic>;
      return content.map((e) => Condominio.fromJson(e)).toList();
    } else {
      throw Exception('Error al listar condominios: ${response.statusCode}');
    }
  }

  Future<Condominio> crear(String nombre, String direccion) async {
    final url = Uri.parse('$_baseUrl/api/admin/condominios');
    final response = await http
        .post(
          url,
          headers: _headers,
          body: jsonEncode({'nombre': nombre, 'direccion': direccion}),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 201) {
      return Condominio.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear condominio: ${response.statusCode}');
    }
  }

  Future<Condominio> actualizar(int id, String nombre, String direccion) async {
    final url = Uri.parse('$_baseUrl/api/admin/condominios/$id');
    final response = await http
        .put(
          url,
          headers: _headers,
          body: jsonEncode({'nombre': nombre, 'direccion': direccion}),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Condominio.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar condominio: ${response.statusCode}');
    }
  }

  Future<void> eliminar(int id) async {
    final url = Uri.parse('$_baseUrl/api/admin/condominios/$id');
    final response = await http
        .delete(url, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar condominio: ${response.statusCode}');
    }
  }

  Future<Condominio> obtenerPorId(int id) async {
    final url = Uri.parse('$_baseUrl/api/admin/condominios/$id');
    final response = await http
        .get(url, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Condominio.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener condominio: ${response.statusCode}');
    }
  }
}
