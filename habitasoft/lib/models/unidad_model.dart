class Unidad {
  final int id;
  final int condominioId;
  final String numeroUnidad;

  Unidad({
    required this.id,
    required this.condominioId,
    required this.numeroUnidad,
  });

  factory Unidad.fromJson(Map<String, dynamic> json) {
    return Unidad(
      id: json['id'] as int,
      condominioId: json['condominioId'] as int,
      numeroUnidad: json['numeroUnidad'] as String,
    );
  }
}
