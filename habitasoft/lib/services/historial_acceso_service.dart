import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/historial_acceso_model.dart';

class HistorialAccesoService {
  static const String _baseUrl = 'http://10.0.2.2:8084';

  final String? _token;

  HistorialAccesoService({String? token}) : _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<List<HistorialAcceso>> listarPorGuardia() async {
    final uri = Uri.parse('$_baseUrl/api/guardia/historial');
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'] as List<dynamic>;
      return content.map((e) => HistorialAcceso.fromJson(e)).toList();
    } else {
      throw Exception('Error al listar historial: ${response.statusCode}');
    }
  }

  Future<List<HistorialAcceso>> listarPorAdmin(int condominioId) async {
    final uri = Uri.parse(
      '$_baseUrl/api/admin/historial?condominioId=$condominioId',
    );
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'] as List<dynamic>;
      return content.map((e) => HistorialAcceso.fromJson(e)).toList();
    } else {
      throw Exception('Error al listar historial: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> obtenerEstadisticasGuardia() async {
    final uri = Uri.parse('$_baseUrl/api/guardia/historial/stats');
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error al obtener estadísticas: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> obtenerEstadisticasAdmin(
    int condominioId,
  ) async {
    final uri = Uri.parse(
      '$_baseUrl/api/admin/historial/stats?condominioId=$condominioId',
    );
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error al obtener estadísticas: ${response.statusCode}');
    }
  }
}
