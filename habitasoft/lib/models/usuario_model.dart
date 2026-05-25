class Usuario {
  final int id;
  final String nombre;
  final String email;
  final String? telefono;
  final String rol;
  final String? fechaCreacion;
  final String? numeroUnidad;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    this.telefono,
    required this.rol,
    this.fechaCreacion,
    this.numeroUnidad,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      telefono: json['telefono'] as String?,
      rol: json['rol'] as String,
      fechaCreacion: json['fechaCreacion'] as String?,
      numeroUnidad: json['numeroUnidad'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'email': email,
      'password': '',
      'telefono': telefono,
      'rol': rol,
      'unidadId': null,
    };
  }
}
