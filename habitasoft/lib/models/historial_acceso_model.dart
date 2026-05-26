class HistorialAcceso {
  final int id;
  final int paseVisitaId;
  final int guardiaId;
  final int residenteId;
  final String nombreVisitante;
  final String codigoQr;
  final String? fechaAcceso;
  final int condominioId;
  final String? guardiaNombre;
  final String? residenteNombre;
  final String? unidadNumero;

  HistorialAcceso({
    required this.id,
    required this.paseVisitaId,
    required this.guardiaId,
    required this.residenteId,
    required this.nombreVisitante,
    required this.codigoQr,
    this.fechaAcceso,
    required this.condominioId,
    this.guardiaNombre,
    this.residenteNombre,
    this.unidadNumero,
  });

  factory HistorialAcceso.fromJson(Map<String, dynamic> json) {
    return HistorialAcceso(
      id: json['id'] as int,
      paseVisitaId: json['paseVisitaId'] as int,
      guardiaId: json['guardiaId'] as int,
      residenteId: json['residenteId'] as int,
      nombreVisitante: json['nombreVisitante'] as String,
      codigoQr: json['codigoQr'] as String,
      fechaAcceso: json['fechaAcceso'] as String?,
      condominioId: json['condominioId'] as int,
      guardiaNombre: json['guardiaNombre'] as String?,
      residenteNombre: json['residenteNombre'] as String?,
      unidadNumero: json['unidadNumero'] as String?,
    );
  }
}
