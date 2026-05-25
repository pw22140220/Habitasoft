import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario_model.dart';

class UsuarioService {
  static const String _baseUrl = 'http://10.0.2.2:8084';

  final String? _token;

  UsuarioService({String? token}) : _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<List<Usuario>> listar(int condominioId, {String? search}) async {
    final queryParams = <String, String>{
      'size': '100',
      'condominioId': condominioId.toString(),
    };
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    final uri = Uri.parse(
      '$_baseUrl/api/admin/usuarios',
    ).replace(queryParameters: queryParams);
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'] as List<dynamic>;
      return content.map((e) => Usuario.fromJson(e)).toList();
    } else {
      throw Exception('Error al listar usuarios: ${response.statusCode}');
    }
  }

  Future<Usuario> crear(Map<String, dynamic> data, int condominioId) async {
    final uri = Uri.parse(
      '$_baseUrl/api/admin/usuarios',
    ).replace(queryParameters: {'condominioId': condominioId.toString()});
    final response = await http
        .post(uri, headers: _headers, body: jsonEncode(data))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 201) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else {
      final msg =
          '${_extractError(response.body)} (status: ${response.statusCode})';
      throw Exception(msg);
    }
  }

  Future<Usuario> actualizar(
    int id,
    Map<String, dynamic> data,
    int condominioId,
  ) async {
    final uri = Uri.parse(
      '$_baseUrl/api/admin/usuarios/$id',
    ).replace(queryParameters: {'condominioId': condominioId.toString()});
    final response = await http
        .put(uri, headers: _headers, body: jsonEncode(data))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else {
      final msg =
          '${_extractError(response.body)} (status: ${response.statusCode})';
      throw Exception(msg);
    }
  }

  Future<void> eliminar(int id) async {
    final url = Uri.parse('$_baseUrl/api/admin/usuarios/$id');
    final response = await http
        .delete(url, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar usuario: ${response.statusCode}');
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
