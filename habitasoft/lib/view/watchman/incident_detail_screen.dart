import 'package:flutter/material.dart';
import 'incident_model.dart';

class IncidentDetailScreen extends StatefulWidget {
  final Incident incident;
  final String userName;

  const IncidentDetailScreen({
    super.key,
    required this.incident,
    required this.userName,
  });

  @override
  State<IncidentDetailScreen> createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  late Incident _incident;
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _incident = widget.incident;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

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

  String _statusLabel(String status) {
    switch (status) {
      case 'nuevo':
        return 'Nuevo';
      case 'en_progreso':
        return 'En Progreso';
      case 'resuelto':
        return 'Resuelto';
      default:
        return status;
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

  void _changeStatus(String newStatus) {
    setState(() {
      _incident = _incident.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );
    });
    Navigator.pop(context, _incident);
  }

  void _addNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    final note = IncidentNote(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      authorName: widget.userName,
      authorRole: 'guard',
      text: text,
      timestamp: DateTime.now(),
    );

    setState(() {
      _incident = _incident.copyWith(
        notes: [..._incident.notes, note],
        updatedAt: DateTime.now(),
      );
      _noteController.clear();
    });
    Navigator.pop(context, _incident);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Incidente'),
        backgroundColor: const Color(0xFF15806C),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _changeStatus,
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder:
                (context) => [
                  if (_incident.status != 'nuevo')
                    const PopupMenuItem(
                      value: 'nuevo',
                      child: Text('Marcar como Nuevo'),
                    ),
                  if (_incident.status != 'en_progreso')
                    const PopupMenuItem(
                      value: 'en_progreso',
                      child: Text('Marcar como En Progreso'),
                    ),
                  if (_incident.status != 'resuelto')
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
            // Estado y prioridad
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(_incident.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _statusColor(_incident.status),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _statusLabel(_incident.status),
                        style: TextStyle(
                          color: _statusColor(_incident.status),
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
                    color: _priorityColor(_incident.priority).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Prioridad ${_incident.priority}',
                    style: TextStyle(
                      color: _priorityColor(_incident.priority),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tipo y ubicación
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
                        _typeIcon(_incident.type),
                        size: 20,
                        color: const Color(0xFF15806C),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _incident.type,
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
                        _incident.location,
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
                        'Reportado por: ${_incident.reporterName}',
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
                        'Creado: ${_formatDateFull(_incident.createdAt)}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  if (_incident.updatedAt != _incident.createdAt) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.update, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Actualizado: ${_formatDateFull(_incident.updatedAt)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Descripción
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
                _incident.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),

            // Adjuntos
            if (_incident.attachments.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Adjuntos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _incident.attachments.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
              ),
            ],

            // Notas / Historial
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Historial de Notas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                if (_incident.status != 'resuelto')
                  Text(
                    '${_incident.notes.length} nota(s)',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            if (_incident.notes.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
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
                  children: [
                    Icon(
                      Icons.note_add_outlined,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sin notas aún',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            else
              ..._incident.notes.map((note) => _NoteCard(note: note)),

            // Agregar nota
            if (_incident.status != 'resuelto') ...[
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
                    const Text(
                      'Agregar Nota',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Escribe una nota...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addNote,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF15806C),
                        ),
                        child: const Text(
                          'Agregar Nota',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  String _formatDateFull(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _NoteCard extends StatelessWidget {
  final IncidentNote note;

  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: Color(0xFF15806C)),
              const SizedBox(width: 6),
              Text(
                '${note.authorName} (${note.authorRole})',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const Spacer(),
              Text(
                '${note.timestamp.hour.toString().padLeft(2, '0')}:${note.timestamp.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
