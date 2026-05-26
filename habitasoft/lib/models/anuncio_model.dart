class Anuncio {
  final int id;
  final String titulo;
  final String contenido;
  final int condominioId;
  final int creadoPorId;
  final String? creadorNombre;
  final String? fechaCreacion;
  final String? fechaExpiracion;
  final bool activo;
  final bool destacado;
  final String? imagenUrl;
  final String destinatario;

  Anuncio({
    required this.id,
    required this.titulo,
    required this.contenido,
    required this.condominioId,
    required this.creadoPorId,
    this.creadorNombre,
    this.fechaCreacion,
    this.fechaExpiracion,
    required this.activo,
    required this.destacado,
    this.imagenUrl,
    this.destinatario = 'ambos',
  });

  factory Anuncio.fromJson(Map<String, dynamic> json) {
    return Anuncio(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      contenido: json['contenido'] as String,
      condominioId: json['condominioId'] as int,
      creadoPorId: json['creadoPorId'] as int,
      creadorNombre: json['creadorNombre'] as String?,
      fechaCreacion: json['fechaCreacion'] as String?,
      fechaExpiracion: json['fechaExpiracion'] as String?,
      activo: json['activo'] as bool? ?? true,
      destacado: json['destacado'] as bool? ?? false,
      imagenUrl: json['imagenUrl'] as String?,
      destinatario: json['destinatario'] as String? ?? 'ambos',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'contenido': contenido,
      if (fechaExpiracion != null) 'fechaExpiracion': fechaExpiracion,
      'activo': activo,
      'destacado': destacado,
      if (imagenUrl != null) 'imagenUrl': imagenUrl,
      'destinatario': destinatario,
    };
  }
}
