class Alerta {
  final int id;
  final String titulo;
  final String mensaje;
  final String prioridad;
  final int condominioId;
  final int creadoPorId;
  final String? fechaCreacion;
  final String? fechaExpiracion;
  final bool activa;

  Alerta({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.prioridad,
    required this.condominioId,
    required this.creadoPorId,
    this.fechaCreacion,
    this.fechaExpiracion,
    required this.activa,
  });

  factory Alerta.fromJson(Map<String, dynamic> json) {
    return Alerta(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      mensaje: json['mensaje'] as String,
      prioridad: json['prioridad'] as String,
      condominioId: json['condominioId'] as int,
      creadoPorId: json['creadoPorId'] as int,
      fechaCreacion: json['fechaCreacion'] as String?,
      fechaExpiracion: json['fechaExpiracion'] as String?,
      activa: json['activa'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'mensaje': mensaje,
      'prioridad': prioridad,
      'condominioId': condominioId,
      'creadoPorId': creadoPorId,
      if (fechaExpiracion != null) 'fechaExpiracion': fechaExpiracion,
    };
  }
}
