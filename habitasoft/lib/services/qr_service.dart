import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pase_de_visita_model.dart';

class QrService {
  static const String _baseUrl = 'http://10.0.2.2:8084';

  final String? _token;

  QrService({String? token}) : _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<PaseDeVisita> generarPase(String nombreVisitante) async {
    final uri = Uri.parse('$_baseUrl/api/residente/pases-visita');
    final body = {'nombreVisitante': nombreVisitante};

    final response = await http
        .post(uri, headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 201) {
      return PaseDeVisita.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al generar pase: ${response.statusCode}');
    }
  }

  Future<List<PaseDeVisita>> listarMisPases() async {
    final uri = Uri.parse('$_baseUrl/api/residente/mis-pases');
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'] as List<dynamic>;
      return content.map((e) => PaseDeVisita.fromJson(e)).toList();
    } else {
      throw Exception('Error al listar pases: ${response.statusCode}');
    }
  }
}
