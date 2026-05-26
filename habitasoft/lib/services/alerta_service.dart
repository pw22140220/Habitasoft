import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/alerta_model.dart';

class AlertaService {
  static const String _baseUrl = 'http://10.0.2.2:8084';

  final String? _token;

  AlertaService({String? token}) : _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<List<Alerta>> listarTodas({int? condominioId}) async {
    final queryParams = <String, String>{};
    if (condominioId != null)
      queryParams['condominioId'] = condominioId.toString();
    final uri = Uri.parse(
      '$_baseUrl/api/admin/alertas',
    ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'] as List<dynamic>;
      return content.map((e) => Alerta.fromJson(e)).toList();
    } else {
      throw Exception('Error al listar alertas: ${response.statusCode}');
    }
  }

  Future<Alerta> crear(
    String titulo,
    String mensaje,
    String prioridad,
    int condominioId,
    int creadoPorId, {
    String? fechaExpiracion,
  }) async {
    final url = Uri.parse('$_baseUrl/api/admin/alertas');
    final body = {
      'titulo': titulo,
      'mensaje': mensaje,
      'prioridad': prioridad,
      'condominioId': condominioId,
      'creadoPorId': creadoPorId,
    };
    if (fechaExpiracion != null) body['fechaExpiracion'] = fechaExpiracion;

    final response = await http
        .post(url, headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 201) {
      return Alerta.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear alerta: ${response.statusCode}');
    }
  }

  Future<Alerta> obtenerPorId(int id) async {
    final url = Uri.parse('$_baseUrl/api/admin/alertas/$id');
    final response = await http
        .get(url, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Alerta.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener alerta: ${response.statusCode}');
    }
  }

  Future<Alerta> actualizar(
    int id,
    String titulo,
    String mensaje,
    String prioridad,
    int condominioId, {
    String? fechaExpiracion,
  }) async {
    final url = Uri.parse('$_baseUrl/api/admin/alertas/$id');
    final body = {
      'titulo': titulo,
      'mensaje': mensaje,
      'prioridad': prioridad,
      'condominioId': condominioId,
      'creadoPorId': 1,
    };
    if (fechaExpiracion != null) body['fechaExpiracion'] = fechaExpiracion;

    final response = await http
        .put(url, headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Alerta.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar alerta: ${response.statusCode}');
    }
  }

  Future<void> eliminar(int id) async {
    final url = Uri.parse('$_baseUrl/api/admin/alertas/$id');
    final response = await http
        .delete(url, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar alerta: ${response.statusCode}');
    }
  }

  Future<List<Alerta>> listarActivasPorCondominio(int condominioId) async {
    final uri = Uri.parse(
      '$_baseUrl/api/residente/alertas',
    ).replace(queryParameters: {'condominioId': condominioId.toString()});
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'] as List<dynamic>;
      return content.map((e) => Alerta.fromJson(e)).toList();
    } else {
      throw Exception(
        'Error al listar alertas activas: ${response.statusCode}',
      );
    }
  }

  Future<List<Alerta>> listarActivasPorCondominioGuardia(
    int condominioId,
  ) async {
    final uri = Uri.parse(
      '$_baseUrl/api/guardia/alertas',
    ).replace(queryParameters: {'condominioId': condominioId.toString()});
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'] as List<dynamic>;
      return content.map((e) => Alerta.fromJson(e)).toList();
    } else {
      throw Exception(
        'Error al listar alertas activas: ${response.statusCode}',
      );
    }
  }
}
