class IncidentNote {
  final String id;
  final String authorName;
  final String authorRole;
  final String text;
  final DateTime timestamp;

  IncidentNote({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.text,
    required this.timestamp,
  });
}

class Incident {
  final String id;
  final String condominiumId;
  final String reporterName;
  final String reporterRole;
  final String type;
  final String location;
  final String description;
  final String priority;
  final String status;
  final List<String> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<IncidentNote> notes;
  final String? assignedTo;

  Incident({
    required this.id,
    required this.condominiumId,
    required this.reporterName,
    this.reporterRole = 'guard',
    required this.type,
    required this.location,
    required this.description,
    required this.priority,
    this.status = 'nuevo',
    this.attachments = const [],
    required this.createdAt,
    required this.updatedAt,
    this.notes = const [],
    this.assignedTo,
  });

  Incident copyWith({
    String? status,
    List<IncidentNote>? notes,
    DateTime? updatedAt,
  }) {
    return Incident(
      id: id,
      condominiumId: condominiumId,
      reporterName: reporterName,
      reporterRole: reporterRole,
      type: type,
      location: location,
      description: description,
      priority: priority,
      status: status ?? this.status,
      attachments: attachments,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      assignedTo: assignedTo,
    );
  }
}

// Datos mock para desarrollo
List<Incident> mockIncidents = [
  Incident(
    id: 'inc_001',
    condominiumId: 'cond_01',
    reporterName: 'Carlos Rodríguez',
    reporterRole: 'guard',
    type: 'Seguridad',
    location: 'Portón principal',
    description:
        'Persona no identificada intentó forzar el portón a las 2:30 AM. Se revisó CCTV y se reforzó vigilancia.',
    priority: 'Alta',
    status: 'en_progreso',
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    notes: [
      IncidentNote(
        id: 'note_001',
        authorName: 'Carlos Rodríguez',
        authorRole: 'guard',
        text:
            'CCTV verificado. Se observó a una persona merodeando. Se aumentó vigilancia en el sector.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ],
  ),
  Incident(
    id: 'inc_002',
    condominiumId: 'cond_01',
    reporterName: 'Carlos Rodríguez',
    reporterRole: 'guard',
    type: 'Mantenimiento',
    location: 'Estacionamiento - Sección B',
    description:
        'Luz del estacionamiento sección B fundida. Necesita reemplazo urgente.',
    priority: 'Media',
    status: 'nuevo',
    createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
  ),
  Incident(
    id: 'inc_003',
    condominiumId: 'cond_01',
    reporterName: 'Carlos Rodríguez',
    reporterRole: 'guard',
    type: 'Seguridad',
    location: 'Acceso vehicular',
    description:
        'Vehiculo sospechoso estacionado frente a la entrada. Se tomó placa y se reportó a admin.',
    priority: 'Alta',
    status: 'nuevo',
    createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
  ),
  Incident(
    id: 'inc_004',
    condominiumId: 'cond_01',
    reporterName: 'Carlos Rodríguez',
    reporterRole: 'guard',
    type: 'General',
    location: 'Área de basura',
    description:
        'Contenedor de basura desbordado. Se solicitó recolección extraordinaria.',
    priority: 'Baja',
    status: 'resuelto',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 10)),
    notes: [
      IncidentNote(
        id: 'note_002',
        authorName: 'Carlos Rodríguez',
        authorRole: 'guard',
        text:
            'Recolección extraordinaria realizada. Contenedor vaciado y área limpia.',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
    ],
  ),
  Incident(
    id: 'inc_005',
    condominiumId: 'cond_01',
    reporterName: 'Carlos Rodríguez',
    reporterRole: 'guard',
    type: 'Mantenimiento',
    location: 'Elevador principal',
    description:
        'Elevador emite ruido extraño al subir. Reportar a mantenimiento para revisión preventiva.',
    priority: 'Media',
    status: 'nuevo',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
