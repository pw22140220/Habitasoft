class Condominio {
  final int id;
  final String nombre;
  final String direccion;
  final String? fechaCreacion;

  Condominio({
    required this.id,
    required this.nombre,
    required this.direccion,
    this.fechaCreacion,
  });

  factory Condominio.fromJson(Map<String, dynamic> json) {
    return Condominio(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      direccion: json['direccion'] as String,
      fechaCreacion: json['fechaCreacion'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'nombre': nombre, 'direccion': direccion};
  }
}
