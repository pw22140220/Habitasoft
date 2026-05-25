class Reservacion {
  final int id;
  final int amenidadId;
  final String? amenidadNombre;
  final int residenteId;
  final String? residenteNombre;
  final String? fechaHoraInicio;
  final String? fechaHoraFin;
  final String estado;

  Reservacion({
    required this.id,
    required this.amenidadId,
    this.amenidadNombre,
    required this.residenteId,
    this.residenteNombre,
    this.fechaHoraInicio,
    this.fechaHoraFin,
    required this.estado,
  });

  factory Reservacion.fromJson(Map<String, dynamic> json) {
    return Reservacion(
      id: json['id'] as int,
      amenidadId: json['amenidadId'] as int,
      amenidadNombre: json['amenidadNombre'] as String?,
      residenteId: json['residenteId'] as int,
      residenteNombre: json['residenteNombre'] as String?,
      fechaHoraInicio: json['fechaHoraInicio'] as String?,
      fechaHoraFin: json['fechaHoraFin'] as String?,
      estado: json['estado'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amenidadId': amenidadId,
      'fechaHoraInicio': fechaHoraInicio,
      'fechaHoraFin': fechaHoraFin,
    };
  }

  String get estadoTexto {
    switch (estado) {
      case 'confirmada':
        return 'Confirmada';
      case 'pendiente':
        return 'Pendiente';
      case 'cancelada':
        return 'Cancelada';
      default:
        return estado;
    }
  }
}
