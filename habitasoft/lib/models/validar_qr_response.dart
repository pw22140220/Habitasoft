class ValidarQrResponse {
  final bool valido;
  final String mensaje;
  final String? nombreVisitante;
  final String? residenteNombre;
  final String? unidad;
  final String? fechaValidez;

  ValidarQrResponse({
    required this.valido,
    required this.mensaje,
    this.nombreVisitante,
    this.residenteNombre,
    this.unidad,
    this.fechaValidez,
  });

  factory ValidarQrResponse.fromJson(Map<String, dynamic> json) {
    return ValidarQrResponse(
      valido: json['valido'] as bool,
      mensaje: json['mensaje'] as String,
      nombreVisitante: json['nombreVisitante'] as String?,
      residenteNombre: json['residenteNombre'] as String?,
      unidad: json['unidad'] as String?,
      fechaValidez: json['fechaValidez'] as String?,
    );
  }
}
