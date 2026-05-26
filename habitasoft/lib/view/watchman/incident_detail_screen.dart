import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/incidente_model.dart';
import '../../providers/incidente_provider.dart';

class IncidentDetailScreen extends StatefulWidget {
  final Incidente incident;
  final String userName;
  final String? token;

  const IncidentDetailScreen({
    super.key,
    required this.incident,
    required this.userName,
    this.token,
  });

  @override
  State<IncidentDetailScreen> createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  late Incidente _incident;

  @override
  void initState() {
    super.initState();
    _incident = widget.incident;
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

  Future<void> _changeStatus(String newStatus) async {
    final provider = context.read<IncidenteProvider>();
    provider.setToken(widget.token);
    final success = await provider.actualizarEstado(_incident.id, newStatus);
    if (success && mounted) {
      setState(() {
        _incident = Incidente(
          id: _incident.id,
          reportadoPorId: _incident.reportadoPorId,
          nombreReportador: _incident.nombreReportador,
          titulo: _incident.titulo,
          descripcion: _incident.descripcion,
          tipo: _incident.tipo,
          ubicacion: _incident.ubicacion,
          prioridad: _incident.prioridad,
          estado: newStatus,
          fechaHoraIncidente: _incident.fechaHoraIncidente,
          fechaActualizacion: _incident.fechaActualizacion,
        );
      });
    }
  }

  Future<void> _openEditScreen() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder:
            (_) => _EditIncidentScreen(
              incident: _incident,
              userName: widget.userName,
              token: widget.token,
            ),
      ),
    );
    if (result == true && mounted) {
      final provider = context.read<IncidenteProvider>();
      provider.setToken(widget.token);
      await provider.cargarMisIncidentes();
      final updated =
          provider.incidentes.where((i) => i.id == _incident.id).firstOrNull;
      if (updated != null && mounted) {
        setState(() => _incident = updated);
      }
    }
  }

  String _formatDateFull(String? dateStr) {
    if (dateStr == null) return '';
    final dt = DateTime.tryParse(dateStr);
    if (dt == null) return '';
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Incidente'),
        backgroundColor: const Color(0xFF15806C),
        elevation: 0,
        actions: [
          if (_incident.estado != 'resuelto')
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.white),
              onPressed: _openEditScreen,
            ),
          if (_incident.estado != 'resuelto')
            PopupMenuButton<String>(
              onSelected: _changeStatus,
              icon: const Icon(Icons.more_vert, color: Colors.white),
              itemBuilder:
                  (context) => [
                    if (_incident.estado != 'nuevo')
                      const PopupMenuItem(
                        value: 'nuevo',
                        child: Text('Marcar como Nuevo'),
                      ),
                    if (_incident.estado != 'en_progreso')
                      const PopupMenuItem(
                        value: 'en_progreso',
                        child: Text('Marcar como En Progreso'),
                      ),
                    if (_incident.estado != 'resuelto')
                      const PopupMenuItem(
                        value: 'resuelto',
                        child: Text('Marcar como Resuelto'),
                      ),
                  ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(_incident.estado).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _statusColor(_incident.estado),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _incident.estadoLabel,
                        style: TextStyle(
                          color: _statusColor(_incident.estado),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _priorityColor(_incident.prioridad).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Prioridad ${_incident.prioridadLabel}',
                    style: TextStyle(
                      color: _priorityColor(_incident.prioridad),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _typeIcon(_incident.tipo),
                        size: 20,
                        color: const Color(0xFF15806C),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _incident.tipo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _incident.ubicacion,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Reportado por: ${_incident.nombreReportador}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Creado: ${_formatDateFull(_incident.fechaHoraIncidente)}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Descripción',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
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
              child: Text(
                _incident.descripcion,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _EditIncidentScreen extends StatefulWidget {
  final Incidente incident;
  final String userName;
  final String? token;

  const _EditIncidentScreen({
    required this.incident,
    required this.userName,
    this.token,
  });

  @override
  State<_EditIncidentScreen> createState() => _EditIncidentScreenState();
}

class _EditIncidentScreenState extends State<_EditIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late String _selectedType;
  late String _selectedPriority;

  final List<String> _types = ['Seguridad', 'Mantenimiento', 'General'];
  final List<String> _priorities = ['ALTA', 'MEDIA', 'BAJA'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.incident.titulo);
    _descriptionController = TextEditingController(
      text: widget.incident.descripcion,
    );
    _locationController = TextEditingController(
      text: widget.incident.ubicacion,
    );
    _selectedType = widget.incident.tipo;
    _selectedPriority = widget.incident.prioridad;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<IncidenteProvider>();
    provider.setToken(widget.token);

    final updated = Incidente(
      id: widget.incident.id,
      reportadoPorId: widget.incident.reportadoPorId,
      titulo: _titleController.text.trim(),
      descripcion: _descriptionController.text.trim(),
      tipo: _selectedType,
      ubicacion: _locationController.text.trim(),
      prioridad: _selectedPriority,
      estado: widget.incident.estado,
      fechaHoraIncidente: widget.incident.fechaHoraIncidente,
      fechaActualizacion: widget.incident.fechaActualizacion,
    );

    final success = await provider.actualizar(widget.incident.id, updated);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incidente actualizado'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Error al actualizar'),
          backgroundColor: Colors.red,
        ),
      );
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
        return p;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Incidente'),
        backgroundColor: const Color(0xFF15806C),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Título',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Título del incidente',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                validator:
                    (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'El título es obligatorio'
                            : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Tipo',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                items:
                    _types
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ubicación',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Ubicación',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                validator:
                    (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'La ubicación es obligatoria'
                            : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Prioridad',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                items:
                    _priorities.map((p) {
                      Color color;
                      switch (p) {
                        case 'ALTA':
                          color = Colors.red;
                        case 'MEDIA':
                          color = Colors.orange;
                        case 'BAJA':
                          color = Colors.blue;
                        default:
                          color = Colors.grey;
                      }
                      return DropdownMenuItem(
                        value: p,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(_priorityLabel(p)),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (v) => setState(() => _selectedPriority = v!),
              ),
              const SizedBox(height: 16),
              const Text(
                'Descripción',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Describe el incidente...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                validator:
                    (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'La descripción es obligatoria'
                            : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF15806C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Guardar Cambios',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
