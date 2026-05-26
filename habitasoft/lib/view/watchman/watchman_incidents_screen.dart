import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/incidente_model.dart';
import '../../providers/incidente_provider.dart';
import 'new_incident_screen.dart';
import 'incident_detail_screen.dart';

class WatchmanIncidentsScreen extends StatefulWidget {
  final String userName;
  final String? token;

  const WatchmanIncidentsScreen({
    super.key,
    required this.userName,
    this.token,
  });

  @override
  State<WatchmanIncidentsScreen> createState() =>
      _WatchmanIncidentsScreenState();
}

class _WatchmanIncidentsScreenState extends State<WatchmanIncidentsScreen> {
  String _selectedFilter = 'Todos';
  String _selectedPriority = 'Todas';
  final List<String> _statusFilters = [
    'Todos',
    'nuevo',
    'en_progreso',
    'resuelto',
  ];
  final List<String> _priorityFilters = ['Todas', 'ALTA', 'MEDIA', 'BAJA'];

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = context.read<IncidenteProvider>();
        provider.setToken(widget.token);
        provider.cargarMisIncidentes();
      });
    }
  }

  List<Incidente> get _filteredIncidents {
    final provider = context.watch<IncidenteProvider>();
    return provider.incidentes.where((inc) {
      final matchesStatus =
          _selectedFilter == 'Todos' || inc.estado == _selectedFilter;
      final matchesPriority =
          _selectedPriority == 'Todas' || inc.prioridad == _selectedPriority;
      return matchesStatus && matchesPriority;
    }).toList();
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder:
                  (_) => NewIncidentScreen(
                    userName: widget.userName,
                    token: widget.token,
                  ),
            ),
          );
          if (result == true && mounted) {
            provider.cargarMisIncidentes();
          }
        },
        backgroundColor: const Color(0xFF15806C),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nuevo Incidente',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filtrar por estado:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        _statusFilters.map((f) {
                          final isSelected = _selectedFilter == f;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(_chipLabel(f)),
                              selected: isSelected,
                              onSelected:
                                  (_) => setState(() => _selectedFilter = f),
                              selectedColor: const Color(0xFF15806C),
                              checkmarkColor: Colors.white,
                              labelStyle: TextStyle(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.grey[700],
                                fontSize: 13,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Filtrar por prioridad:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        _priorityFilters.map((f) {
                          final isSelected = _selectedPriority == f;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(_priorityLabel(f)),
                              selected: isSelected,
                              onSelected:
                                  (_) => setState(() => _selectedPriority = f),
                              selectedColor: const Color(0xFF15806C),
                              checkmarkColor: Colors.white,
                              labelStyle: TextStyle(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.grey[700],
                                fontSize: 13,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              '${_filteredIncidents.length} incidente(s)',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child:
                provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredIncidents.isEmpty
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
                            'No hay incidentes con estos filtros',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredIncidents.length,
                      itemBuilder: (context, index) {
                        final inc = _filteredIncidents[index];
                        return _IncidentCard(
                          incident: inc,
                          onTap: () async {
                            final changed = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => IncidentDetailScreen(
                                      incident: inc,
                                      userName: widget.userName,
                                      token: widget.token,
                                    ),
                              ),
                            );
                            if (changed == true && mounted) {
                              provider.cargarMisIncidentes();
                            }
                          },
                          onDelete: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder:
                                  (ctx) => AlertDialog(
                                    title: const Text('Eliminar incidente'),
                                    content: const Text(
                                      '¿Estás seguro de eliminar este incidente?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(ctx, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(ctx, true),
                                        child: const Text(
                                          'Eliminar',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                            if (confirm == true) {
                              await provider.eliminar(inc.id);
                            }
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  String _chipLabel(String status) {
    switch (status) {
      case 'nuevo':
        return 'Nuevos';
      case 'en_progreso':
        return 'En Progreso';
      case 'resuelto':
        return 'Resueltos';
      default:
        return 'Todos';
    }
  }

  String _priorityLabel(String p) {
    switch (p) {
      case 'ALTA':
        return 'Alta';
      case 'MEDIA':
        return 'Media';
      case 'BAJA':
        return 'Baja';
      default:
        return 'Todas';
    }
  }
}

class _IncidentCard extends StatelessWidget {
  final Incidente incident;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _IncidentCard({
    required this.incident,
    required this.onTap,
    required this.onDelete,
  });

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
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        border: Border.all(
          color:
              incident.estado == 'nuevo'
                  ? Colors.red.withOpacity(0.2)
                  : Colors.grey[200]!,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
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
                        color: _statusColor(incident.estado).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _typeIcon(incident.tipo),
                        size: 20,
                        color: _statusColor(incident.estado),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${incident.tipo} - ${incident.ubicacion}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(incident.fechaHoraIncidente),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(incident.estado),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  incident.descripcion,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _priorityColor(
                          incident.prioridad,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        incident.prioridadLabel,
                        style: TextStyle(
                          fontSize: 11,
                          color: _priorityColor(incident.prioridad),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String estado) {
    Color color;
    String label;
    switch (estado) {
      case 'nuevo':
        color = Colors.red;
        label = 'Nuevo';
      case 'en_progreso':
        color = Colors.orange;
        label = 'En Progreso';
      case 'resuelto':
        color = Colors.green;
        label = 'Resuelto';
      default:
        color = Colors.grey;
        label = estado;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
