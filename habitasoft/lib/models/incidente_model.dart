class Incidente {
  final int id;
  final int reportadoPorId;
  final int? condominioId;
  final String nombreReportador;
  final String titulo;
  final String descripcion;
  final String tipo;
  final String ubicacion;
  final String prioridad;
  final String estado;
  final String? fechaHoraIncidente;
  final String? fechaActualizacion;

  Incidente({
    required this.id,
    required this.reportadoPorId,
    this.condominioId,
    this.nombreReportador = '',
    required this.titulo,
    required this.descripcion,
    required this.tipo,
    required this.ubicacion,
    required this.prioridad,
    this.estado = 'nuevo',
    this.fechaHoraIncidente,
    this.fechaActualizacion,
  });

  factory Incidente.fromJson(Map<String, dynamic> json) {
    return Incidente(
      id: json['id'] as int,
      reportadoPorId: json['reportadoPorId'] as int,
      condominioId: json['condominioId'] as int?,
      nombreReportador: json['nombreReportador'] as String? ?? '',
      titulo: json['titulo'] as String? ?? '',
      descripcion: json['descripcion'] as String? ?? '',
      tipo: json['tipo'] as String? ?? 'General',
      ubicacion: json['ubicacion'] as String? ?? '',
      prioridad: json['prioridad'] as String? ?? 'MEDIA',
      estado: json['estado'] as String? ?? 'nuevo',
      fechaHoraIncidente: json['fechaHoraIncidente'] as String?,
      fechaActualizacion: json['fechaActualizacion'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'tipo': tipo,
      'ubicacion': ubicacion,
      'prioridad': prioridad,
    };
  }

  String get prioridadLabel {
    switch (prioridad) {
      case 'ALTA':
        return 'Alta';
      case 'MEDIA':
        return 'Media';
      case 'BAJA':
        return 'Baja';
      default:
        return prioridad;
    }
  }

  String get estadoLabel {
    switch (estado) {
      case 'nuevo':
        return 'Nuevo';
      case 'en_progreso':
        return 'En Progreso';
      case 'resuelto':
        return 'Resuelto';
      default:
        return estado;
    }
  }
}
