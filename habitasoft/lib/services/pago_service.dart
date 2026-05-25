import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pago_model.dart';

class PagoService {
  static const String _baseUrl = 'http://10.0.2.2:8084';

  final String? _token;

  PagoService({String? token}) : _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<List<Pago>> listarPagosAdmin({
    String? estado,
    int? condominioId,
  }) async {
    final queryParams = <String, String>{};
    if (estado != null && estado.isNotEmpty) {
      queryParams['estado'] = estado;
    }
    if (condominioId != null) {
      queryParams['condominioId'] = condominioId.toString();
    }
    final uri = Uri.parse(
      '$_baseUrl/api/admin/pagos',
    ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'] as List<dynamic>;
      return content.map((e) => Pago.fromJson(e)).toList();
    } else {
      throw Exception('Error al listar pagos: ${response.statusCode}');
    }
  }

  Future<List<Pago>> listarPagosPorResidente(int residenteId) async {
    final uri = Uri.parse('$_baseUrl/api/admin/pagos/residentes/$residenteId');
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'] as List<dynamic>;
      return content.map((e) => Pago.fromJson(e)).toList();
    } else {
      throw Exception(
        'Error al listar pagos del residente: ${response.statusCode}',
      );
    }
  }

  Future<Pago> crearRecordatorio(
    int residenteId,
    double monto,
    String? periodo,
    String? fechaVencimiento,
  ) async {
    final url = Uri.parse('$_baseUrl/api/admin/pagos/recordatorio');
    final body = <String, dynamic>{'residenteId': residenteId, 'monto': monto};
    if (periodo != null) body['periodo'] = periodo;
    if (fechaVencimiento != null) {
      body['fechaVencimiento'] = fechaVencimiento;
    }

    final response = await http
        .post(url, headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 201) {
      return Pago.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear recordatorio: ${response.statusCode}');
    }
  }

  Future<Pago> registrarPagoManual(
    int id, {
    String metodoPago = 'efectivo',
  }) async {
    final url = Uri.parse(
      '$_baseUrl/api/admin/pagos/$id/registrar-pago',
    ).replace(queryParameters: {'metodoPago': metodoPago});
    final response = await http
        .put(url, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Pago.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al registrar pago manual: ${response.statusCode}');
    }
  }

  Future<void> eliminar(int id) async {
    final url = Uri.parse('$_baseUrl/api/admin/pagos/$id');
    final response = await http
        .delete(url, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar pago: ${response.statusCode}');
    }
  }

  Future<List<Pago>> listarMisPagos() async {
    final uri = Uri.parse('$_baseUrl/api/residente/pagos');
    print(
      '[PagoService] Token: ${_token != null ? "Bearer ${_token!.substring(0, 20)}..." : "null"}',
    );
    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> content = body['content'] as List<dynamic>;
      return content.map((e) => Pago.fromJson(e)).toList();
    } else {
      throw Exception('Error al listar mis pagos: ${response.statusCode}');
    }
  }

  Future<Pago> marcarComoPagado(
    int id, {
    String metodoPago = 'transferencia',
  }) async {
    final url = Uri.parse(
      '$_baseUrl/api/residente/pagos/$id/pagar',
    ).replace(queryParameters: {'metodoPago': metodoPago});
    final response = await http
        .put(url, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Pago.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al marcar como pagado: ${response.statusCode}');
    }
  }
}
