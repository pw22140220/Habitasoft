import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pase_de_visita_model.dart';
import '../models/validar_qr_response.dart';

class QrService {
  static const String _baseUrl = 'http://10.0.2.2:8084';

  final String? _token;

  QrService({String? token}) : _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<PaseDeVisita> generarPase(
    String nombreVisitante, {
    String? fechaValidez,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/residente/pases-visita');
    final body = <String, dynamic>{'nombreVisitante': nombreVisitante};
    if (fechaValidez != null) body['fechaValidez'] = fechaValidez;

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

  Future<ValidarQrResponse> validarQR(String codigoQr) async {
    final uri = Uri.parse('$_baseUrl/api/guardia/validar-qr');
    final body = {'codigoQr': codigoQr};

    final response = await http
        .post(uri, headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return ValidarQrResponse.fromJson(jsonDecode(response.body));
    }
    if (response.body.isEmpty) {
      throw Exception('Error al validar QR: ${response.statusCode}');
    }
    final Map<String, dynamic> errorBody = jsonDecode(response.body);
    final String errorMsg =
        errorBody['message'] as String? ?? 'Error al validar QR';
    throw Exception(errorMsg);
  }
}
