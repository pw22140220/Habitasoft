import 'package:flutter/material.dart';
import 'incident_model.dart';
import 'incident_detail_screen.dart';
import 'new_incident_screen.dart';

class WatchmanIncidentsScreen extends StatefulWidget {
  final String userName;

  const WatchmanIncidentsScreen({super.key, required this.userName});

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
  final List<String> _priorityFilters = ['Todas', 'Alta', 'Media', 'Baja'];

  List<Incident> get _filteredIncidents {
    return mockIncidents.where((inc) {
      final matchesStatus =
          _selectedFilter == 'Todos' || inc.status == _selectedFilter;
      final matchesPriority =
          _selectedPriority == 'Todas' || inc.priority == _selectedPriority;
      return matchesStatus && matchesPriority;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incidentes'),
        backgroundColor: const Color(0xFF15806C),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push<Incident>(
            context,
            MaterialPageRoute(
              builder: (_) => NewIncidentScreen(userName: widget.userName),
            ),
          );
          if (result != null && mounted) {
            setState(() {});
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
          // Filtros
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

          // Contador
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              '${_filteredIncidents.length} incidente(s)',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),

          // Lista de incidentes
          Expanded(
            child:
                _filteredIncidents.isEmpty
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
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => IncidentDetailScreen(
                                      incident: inc,
                                      userName: widget.userName,
                                    ),
                              ),
                            );
                            if (mounted) setState(() {});
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
      case 'Alta':
        return 'Alta';
      case 'Media':
        return 'Media';
      case 'Baja':
        return 'Baja';
      default:
        return 'Todas';
    }
  }
}

class _IncidentCard extends StatelessWidget {
  final Incident incident;
  final VoidCallback onTap;

  const _IncidentCard({required this.incident, required this.onTap});

  Color _statusColor(String status) {
    switch (status) {
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

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.red;
      case 'Media':
        return Colors.orange;
      case 'Baja':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
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
              incident.status == 'nuevo'
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
                        color: _statusColor(incident.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _typeIcon(incident.type),
                        size: 20,
                        color: _statusColor(incident.status),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${incident.type} - ${incident.location}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(incident.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(incident.status),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  incident.description,
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
                          incident.priority,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        incident.priority,
                        style: TextStyle(
                          fontSize: 11,
                          color: _priorityColor(incident.priority),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
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

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    switch (status) {
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
        label = status;
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

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
