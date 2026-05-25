import 'package:flutter/material.dart';
import '../../models/reservacion_model.dart';
import '../../services/reservacion_service.dart';

class ResidenteReservacionesScreen extends StatefulWidget {
  final String userName;
  final String? token;

  const ResidenteReservacionesScreen({
    super.key,
    required this.userName,
    this.token,
  });

  @override
  State<ResidenteReservacionesScreen> createState() =>
      _ResidenteReservacionesScreenState();
}

class _ResidenteReservacionesScreenState
    extends State<ResidenteReservacionesScreen> {
  List<Reservacion> _reservaciones = [];
  bool _isLoading = false;
  String? _error;

  ReservacionService get _service => ReservacionService(token: widget.token);

  @override
  void initState() {
    super.initState();
    _cargarReservaciones();
  }

  Future<void> _cargarReservaciones() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final reservaciones = await _service.listarMisReservaciones();
      setState(() => _reservaciones = reservaciones);
    } catch (e) {
      setState(() => _error = 'Error al cargar reservaciones');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _cancelarReservacion(Reservacion reservacion) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Cancelar reservación'),
            content: Text(
              '¿Estás seguro de cancelar la reservación de "${reservacion.amenidadNombre ?? 'amenidad'}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Sí, cancelar'),
              ),
            ],
          ),
    );
    if (confirm != true) return;

    try {
      await _service.cancelar(reservacion.id);
      _cargarReservaciones();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reservación cancelada'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString().replaceFirst('Exception: ', '')}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatFecha(String? fecha) {
    if (fecha == null) return '—';
    try {
      final dt = DateTime.parse(fecha);
      final dia = dt.day.toString().padLeft(2, '0');
      final mes = dt.month.toString().padLeft(2, '0');
      final hora = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');
      return '$dia/$mes/${dt.year} $hora:$min';
    } catch (_) {
      return fecha;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Mis Reservaciones'),
        backgroundColor: const Color(0xFF0B64D8),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _cargarReservaciones,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              )
              : _reservaciones.isEmpty
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No tienes reservaciones',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Reserva una amenidad desde el calendario',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: _cargarReservaciones,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _reservaciones.length,
                  itemBuilder:
                      (ctx, i) => _ReservacionCard(
                        reservacion: _reservaciones[i],
                        fechaInicio: _formatFecha(
                          _reservaciones[i].fechaHoraInicio,
                        ),
                        fechaFin: _formatFecha(_reservaciones[i].fechaHoraFin),
                        onCancelar:
                            _reservaciones[i].estado == 'cancelada'
                                ? null
                                : () => _cancelarReservacion(_reservaciones[i]),
                      ),
                ),
              ),
    );
  }
}

class _ReservacionCard extends StatelessWidget {
  final Reservacion reservacion;
  final String fechaInicio;
  final String fechaFin;
  final VoidCallback? onCancelar;

  const _ReservacionCard({
    required this.reservacion,
    required this.fechaInicio,
    required this.fechaFin,
    this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    final Color estadoColor;
    switch (reservacion.estado) {
      case 'confirmada':
        estadoColor = Colors.green;
        break;
      case 'cancelada':
        estadoColor = Colors.red;
        break;
      default:
        estadoColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: estadoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.calendar_today, color: estadoColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reservacion.amenidadNombre ??
                          'Amenidad #${reservacion.amenidadId}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$fechaInicio — $fechaFin',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: estadoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  reservacion.estadoTexto,
                  style: TextStyle(
                    fontSize: 12,
                    color: estadoColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (onCancelar != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onCancelar,
                icon: const Icon(
                  Icons.cancel_outlined,
                  size: 18,
                  color: Colors.red,
                ),
                label: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
