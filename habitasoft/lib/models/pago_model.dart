class Pago {
  final int id;
  final int residenteId;
  final String residenteNombre;
  final double monto;
  final String? periodo;
  final String? fechaVencimiento;
  final String estado;
  final String? fechaPago;
  final String? metodoPago;

  Pago({
    required this.id,
    required this.residenteId,
    required this.residenteNombre,
    required this.monto,
    this.periodo,
    this.fechaVencimiento,
    required this.estado,
    this.fechaPago,
    this.metodoPago,
  });

  factory Pago.fromJson(Map<String, dynamic> json) {
    return Pago(
      id: json['id'] as int,
      residenteId: json['residenteId'] as int,
      residenteNombre: json['residenteNombre'] as String,
      monto: (json['monto'] as num).toDouble(),
      periodo: json['periodo'] as String?,
      fechaVencimiento: json['fechaVencimiento'] as String?,
      estado: json['estado'] as String,
      fechaPago: json['fechaPago'] as String?,
      metodoPago: json['metodoPago'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'residenteId': residenteId,
      'monto': monto,
      'periodo': periodo,
      'fechaVencimiento': fechaVencimiento,
    };
  }

  String get estadoTexto {
    switch (estado) {
      case 'pendiente':
        return 'Pendiente';
      case 'pagado':
        return 'Pagado';
      case 'vencido':
        return 'Vencido';
      default:
        return estado;
    }
  }

  String get metodoPagoTexto {
    switch (metodoPago) {
      case 'transferencia':
        return 'Transferencia';
      case 'tarjeta':
        return 'Tarjeta';
      case 'efectivo':
        return 'Efectivo';
      default:
        return metodoPago ?? '—';
    }
  }
}
