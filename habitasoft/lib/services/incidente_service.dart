import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/incidente_model.dart';

class IncidenteService {
  static const String _baseUrl = 'http://10.0.2.2:8084';
  final String? _token;

  IncidenteService({String? token}) : _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<Incidente> crear(Incidente incidente) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/api/incidentes'),
          headers: _headers,
          body: jsonEncode(incidente.toJson()),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 201) {
      return Incidente.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al crear incidente: ${response.statusCode}');
  }

  Future<List<Incidente>> listarMisIncidentes() async {
    final response = await http
        .get(
          Uri.parse('$_baseUrl/api/incidentes/mis-incidentes'),
          headers: _headers,
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'];
      return content.map((e) => Incidente.fromJson(e)).toList();
    }
    throw Exception('Error al cargar incidentes: ${response.statusCode}');
  }

  Future<List<Incidente>> listarTodos({int? condominioId}) async {
    final uri = Uri.parse('$_baseUrl/api/admin/incidentes').replace(
      queryParameters:
          condominioId != null
              ? {'condominioId': condominioId.toString()}
              : null,
    );
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'];
      return content.map((e) => Incidente.fromJson(e)).toList();
    }
    throw Exception('Error al cargar incidentes: ${response.statusCode}');
  }

  Future<Incidente> obtenerPorId(int id) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/api/incidentes/$id'), headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Incidente.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al obtener incidente: ${response.statusCode}');
  }

  Future<Incidente> actualizar(int id, Incidente incidente) async {
    final response = await http
        .put(
          Uri.parse('$_baseUrl/api/incidentes/$id'),
          headers: _headers,
          body: jsonEncode(incidente.toJson()),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Incidente.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al actualizar incidente: ${response.statusCode}');
  }

  Future<void> actualizarEstado(int id, String estado) async {
    final response = await http
        .patch(
          Uri.parse('$_baseUrl/api/incidentes/$id/estado?estado=$estado'),
          headers: _headers,
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar estado: ${response.statusCode}');
    }
  }

  Future<void> eliminar(int id) async {
    final response = await http
        .delete(Uri.parse('$_baseUrl/api/incidentes/$id'), headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar incidente: ${response.statusCode}');
    }
  }
}
