class Amenidad {
  final int id;
  final String nombre;
  final int? capacidadMaxima;
  final int condominioId;

  Amenidad({
    required this.id,
    required this.nombre,
    this.capacidadMaxima,
    required this.condominioId,
  });

  factory Amenidad.fromJson(Map<String, dynamic> json) {
    return Amenidad(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      capacidadMaxima: json['capacidadMaxima'] as int?,
      condominioId: json['condominioId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'condominioId': condominioId,
      if (capacidadMaxima != null) 'capacidadMaxima': capacidadMaxima,
    };
  }
}
