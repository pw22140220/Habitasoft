class PaseDeVisita {
  final int id;
  final int residenteId;
  final String? nombreVisitante;
  final String? codigoQr;
  final String? fechaValidez;
  final String estado;
  final String? fechaCreacion;

  PaseDeVisita({
    required this.id,
    required this.residenteId,
    this.nombreVisitante,
    this.codigoQr,
    this.fechaValidez,
    required this.estado,
    this.fechaCreacion,
  });

  factory PaseDeVisita.fromJson(Map<String, dynamic> json) {
    return PaseDeVisita(
      id: json['id'] as int,
      residenteId: json['residenteId'] as int,
      nombreVisitante: json['nombreVisitante'] as String?,
      codigoQr: json['codigoQr'] as String?,
      fechaValidez: json['fechaValidez'] as String?,
      estado: json['estado'] as String,
      fechaCreacion: json['fechaCreacion'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'nombreVisitante': nombreVisitante};
  }

  String get estadoTexto {
    switch (estado) {
      case 'activo':
        return 'Activo';
      case 'usado':
        return 'Usado';
      case 'expirado':
        return 'Expirado';
      default:
        return estado;
    }
  }
}
