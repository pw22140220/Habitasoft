import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/unidad_model.dart';

class UnidadService {
  static const String _baseUrl = 'http://10.0.2.2:8084';

  final String? _token;

  UnidadService({String? token}) : _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<List<Unidad>> listarPorCondominio(int condominioId) async {
    final uri = Uri.parse(
      '$_baseUrl/api/admin/unidades',
    ).replace(queryParameters: {'condominioId': condominioId.toString()});
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Unidad.fromJson(e)).toList();
    } else {
      throw Exception('Error al listar unidades');
    }
  }

  Future<Unidad> crear(String numeroUnidad, int condominioId) async {
    final uri = Uri.parse(
      '$_baseUrl/api/admin/unidades',
    ).replace(queryParameters: {'condominioId': condominioId.toString()});
    final response = await http
        .post(
          uri,
          headers: _headers,
          body: jsonEncode({'numeroUnidad': numeroUnidad}),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 201) {
      return Unidad.fromJson(jsonDecode(response.body));
    } else {
      final msg = _extractError(response.body);
      throw Exception(msg);
    }
  }

  Future<Unidad> actualizar(
    int id,
    String numeroUnidad,
    int condominioId,
  ) async {
    final uri = Uri.parse(
      '$_baseUrl/api/admin/unidades/$id',
    ).replace(queryParameters: {'condominioId': condominioId.toString()});
    final response = await http
        .put(
          uri,
          headers: _headers,
          body: jsonEncode({'numeroUnidad': numeroUnidad}),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Unidad.fromJson(jsonDecode(response.body));
    } else {
      final msg = _extractError(response.body);
      throw Exception(msg);
    }
  }

  Future<void> eliminar(int id) async {
    final url = Uri.parse('$_baseUrl/api/admin/unidades/$id');
    final response = await http
        .delete(url, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar unidad');
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
