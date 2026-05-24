import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/amenidad_model.dart';

class AmenidadService {
  static const String _baseUrl = 'http://10.0.2.2:8084';

  final String? _token;

  AmenidadService({String? token}) : _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<List<Amenidad>> listarPorCondominio(int condominioId) async {
    final uri = Uri.parse(
      '$_baseUrl/api/admin/amenidades',
    ).replace(queryParameters: {'condominioId': condominioId.toString()});
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'] as List<dynamic>;
      return content.map((e) => Amenidad.fromJson(e)).toList();
    } else {
      throw Exception('Error al listar amenidades: ${response.statusCode}');
    }
  }

  Future<Amenidad> crear(
    String nombre,
    int condominioId,
    int? capacidadMaxima,
  ) async {
    final url = Uri.parse('$_baseUrl/api/admin/amenidades');
    final body = {'nombre': nombre, 'condominioId': condominioId};
    if (capacidadMaxima != null) body['capacidadMaxima'] = capacidadMaxima;

    final response = await http
        .post(url, headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 201) {
      return Amenidad.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear amenidad: ${response.statusCode}');
    }
  }

  Future<Amenidad> actualizar(
    int id,
    String nombre,
    int condominioId,
    int? capacidadMaxima,
  ) async {
    final url = Uri.parse('$_baseUrl/api/admin/amenidades/$id');
    final body = {'nombre': nombre, 'condominioId': condominioId};
    if (capacidadMaxima != null) body['capacidadMaxima'] = capacidadMaxima;

    final response = await http
        .put(url, headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Amenidad.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar amenidad: ${response.statusCode}');
    }
  }

  Future<void> eliminar(int id) async {
    final url = Uri.parse('$_baseUrl/api/admin/amenidades/$id');
    final response = await http
        .delete(url, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar amenidad: ${response.statusCode}');
    }
  }

  Future<List<Amenidad>> listarResidente(int condominioId) async {
    final uri = Uri.parse(
      '$_baseUrl/api/residente/amenidades',
    ).replace(queryParameters: {'condominioId': condominioId.toString()});
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'] as List<dynamic>;
      return content.map((e) => Amenidad.fromJson(e)).toList();
    } else {
      throw Exception('Error al listar amenidades: ${response.statusCode}');
    }
  }
}
