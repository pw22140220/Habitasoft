import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/incidente_provider.dart';
import 'admin_state.dart';

class AdminIncidentsScreen extends StatefulWidget {
  const AdminIncidentsScreen({super.key});

  @override
  State<AdminIncidentsScreen> createState() => _AdminIncidentsScreenState();
}

class _AdminIncidentsScreenState extends State<AdminIncidentsScreen> {
  void _cargarIncidentes() {
    final adminState = context.read<AdminState>();
    context.read<IncidenteProvider>().cargarTodos(
      condominioId: adminState.selectedCondominio?.id,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminState>().addListener(_cargarIncidentes);
      _cargarIncidentes();
    });
  }

  @override
  void dispose() {
    try {
      context.read<AdminState>().removeListener(_cargarIncidentes);
    } catch (_) {}
    super.dispose();
  }

  Color _statusColor(String estado) {
    switch (estado) {
      case 'nuevo':
        return Colors.red;
      case 'en_progreso':
        return Colors.orange;
      case 'resuelto':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _priorityColor(String prioridad) {
    switch (prioridad) {
      case 'ALTA':
        return Colors.red;
      case 'MEDIA':
        return Colors.orange;
      case 'BAJA':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _typeIcon(String tipo) {
    switch (tipo) {
      case 'Seguridad':
        return Icons.security;
      case 'Mantenimiento':
        return Icons.build;
      case 'General':
        return Icons.info_outline;
      default:
        return Icons.report;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    final dt = DateTime.tryParse(dateStr);
    if (dt == null) return '';
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IncidenteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incidentes'),
        backgroundColor: const Color(0xFF15806C),
        elevation: 0,
      ),
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      provider.error!,
                      style: TextStyle(color: Colors.red[600], fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _cargarIncidentes(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              )
              : provider.incidentes.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay incidentes reportados',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: () => provider.cargarTodos(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.incidentes.length,
                  itemBuilder: (context, index) {
                    final inc = provider.incidentes[index];
                    return Dismissible(
                      key: Key('inc_${inc.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        return await showDialog<bool>(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                title: const Text('Eliminar incidente'),
                                content: Text(
                                  '¿Eliminar el incidente "${inc.titulo}"?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text(
                                      'Eliminar',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      onDismissed: (_) => provider.eliminar(inc.id),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: _statusColor(
                                        inc.estado,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      _typeIcon(inc.tipo),
                                      size: 20,
                                      color: _statusColor(inc.estado),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          inc.titulo,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${inc.tipo} - ${inc.ubicacion}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Reportado por: ${inc.nombreReportador}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    _formatDate(inc.fechaHoraIncidente),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                inc.descripcion,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _statusColor(
                                        inc.estado,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      inc.estadoLabel,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _statusColor(inc.estado),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _priorityColor(
                                        inc.prioridad,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      inc.prioridadLabel,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _priorityColor(inc.prioridad),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
