import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anuncio_model.dart';

class AnuncioService {
  static const String _baseUrl = 'http://10.0.2.2:8084';

  final String? _token;

  AnuncioService({String? token}) : _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<List<Anuncio>> listar(int condominioId) async {
    final uri = Uri.parse('$_baseUrl/api/admin/anuncios').replace(
      queryParameters: {'condominioId': condominioId.toString(), 'size': '100'},
    );
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'] as List<dynamic>;
      return content.map((e) => Anuncio.fromJson(e)).toList();
    } else {
      throw Exception('Error al listar anuncios');
    }
  }

  Future<Anuncio> crear(Map<String, dynamic> data, int condominioId) async {
    final uri = Uri.parse(
      '$_baseUrl/api/admin/anuncios',
    ).replace(queryParameters: {'condominioId': condominioId.toString()});
    final response = await http
        .post(uri, headers: _headers, body: jsonEncode(data))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 201) {
      return Anuncio.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(_extractError(response.body));
    }
  }

  Future<Anuncio> actualizar(int id, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/api/admin/anuncios/$id');
    final response = await http
        .put(url, headers: _headers, body: jsonEncode(data))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Anuncio.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(_extractError(response.body));
    }
  }

  Future<void> eliminar(int id) async {
    final url = Uri.parse('$_baseUrl/api/admin/anuncios/$id');
    final response = await http
        .delete(url, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar anuncio');
    }
  }

  Future<List<Anuncio>> listarResidente(int condominioId) async {
    final uri = Uri.parse('$_baseUrl/api/residente/anuncios').replace(
      queryParameters: {'condominioId': condominioId.toString(), 'size': '100'},
    );
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'] as List<dynamic>;
      return content.map((e) => Anuncio.fromJson(e)).toList();
    } else {
      throw Exception('Error al listar anuncios');
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
