import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reservacion_model.dart';

class ReservacionService {
  static const String _baseUrl = 'http://10.0.2.2:8084';

  final String? _token;

  ReservacionService({String? token}) : _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<List<Reservacion>> listarMisReservaciones() async {
    final uri = Uri.parse('$_baseUrl/api/residente/reservaciones');
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'] as List<dynamic>;
      return content.map((e) => Reservacion.fromJson(e)).toList();
    } else {
      throw Exception('Error al listar reservaciones: ${response.statusCode}');
    }
  }

  Future<Reservacion> crear(
    int amenidadId,
    String fechaHoraInicio,
    String fechaHoraFin,
  ) async {
    final uri = Uri.parse('$_baseUrl/api/residente/reservaciones');
    final body = {
      'amenidadId': amenidadId,
      'fechaHoraInicio': fechaHoraInicio,
      'fechaHoraFin': fechaHoraFin,
    };

    final response = await http
        .post(uri, headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 201) {
      return Reservacion.fromJson(jsonDecode(response.body));
    } else {
      final msg = _extractError(response.body);
      throw Exception(msg);
    }
  }

  Future<void> cancelar(int id) async {
    final url = Uri.parse('$_baseUrl/api/residente/reservaciones/$id');
    final response = await http
        .delete(url, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 204) {
      throw Exception('Error al cancelar reservación: ${response.statusCode}');
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
