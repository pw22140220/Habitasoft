import 'package:flutter/material.dart';

// Modelos de datos compartidos entre Admin y Resident

// Modelo para Condominio
class Condominium {
  final String id;
  final String name;
  final String address;
  final int totalResidents;
  final String imageUrl;

  Condominium({
    required this.id,
    required this.name,
    required this.address,
    required this.totalResidents,
    required this.imageUrl,
  });

  // Método para convertir a Map (útil para persistencia)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'totalResidents': totalResidents,
      'imageUrl': imageUrl,
    };
  }

  // Factory para crear desde Map
  factory Condominium.fromMap(Map<String, dynamic> map) {
    return Condominium(
      id: map['id'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      totalResidents: map['totalResidents'] as int,
      imageUrl: map['imageUrl'] as String,
    );
  }
}

// Modelo para Residente
class Resident {
  final String id;
  final String name;
  final String apartment;
  final String email;
  final String phone;
  final String condominiumId;
  final DateTime registrationDate;
  final String status; // 'active', 'inactive', 'pending'

  Resident({
    required this.id,
    required this.name,
    required this.apartment,
    required this.email,
    required this.phone,
    required this.condominiumId,
    required this.registrationDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'apartment': apartment,
      'email': email,
      'phone': phone,
      'condominiumId': condominiumId,
      'registrationDate': registrationDate.toIso8601String(),
      'status': status,
    };
  }

  factory Resident.fromMap(Map<String, dynamic> map) {
    return Resident(
      id: map['id'] as String,
      name: map['name'] as String,
      apartment: map['apartment'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      condominiumId: map['condominiumId'] as String,
      registrationDate: DateTime.parse(map['registrationDate'] as String),
      status: map['status'] as String,
    );
  }

  // Método para obtener el color según el estado
  Color getStatusColor() {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Método para obtener el texto de estado
  String getStatusText() {
    switch (status) {
      case 'active':
        return 'Activo';
      case 'inactive':
        return 'Inactivo';
      case 'pending':
        return 'Pendiente';
      default:
        return 'Desconocido';
    }
  }
}

// Modelo para Anuncio
class Announcement {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final String author;
  final String condominiumId;
  final bool isPublished;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.author,
    required this.condominiumId,
    required this.isPublished,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'author': author,
      'condominiumId': condominiumId,
      'isPublished': isPublished,
    };
  }

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      date: DateTime.parse(map['date'] as String),
      author: map['author'] as String,
      condominiumId: map['condominiumId'] as String,
      isPublished: map['isPublished'] as bool,
    );
  }
}

// Modelo para Recordatorio de Pago
class PaymentReminder {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final String priority; // 'high', 'medium', 'low'
  final String condominiumId;
  final bool sent;
  final String? residentId; // null si es para todos

  PaymentReminder({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.priority,
    required this.condominiumId,
    required this.sent,
    this.residentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'date': date.toIso8601String(),
      'priority': priority,
      'condominiumId': condominiumId,
      'sent': sent,
      'residentId': residentId,
    };
  }

  factory PaymentReminder.fromMap(Map<String, dynamic> map) {
    return PaymentReminder(
      id: map['id'] as String,
      title: map['title'] as String,
      message: map['message'] as String,
      date: DateTime.parse(map['date'] as String),
      priority: map['priority'] as String,
      condominiumId: map['condominiumId'] as String,
      sent: map['sent'] as bool,
      residentId: map['residentId'] as String?,
    );
  }

  // Método para obtener el color según la prioridad
  Color getPriorityColor() {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Método para obtener el texto de prioridad
  String getPriorityText() {
    switch (priority) {
      case 'high':
        return 'Alta';
      case 'medium':
        return 'Media';
      case 'low':
        return 'Baja';
      default:
        return 'Normal';
    }
  }
}

// Modelo para Reserva
class Reservation {
  final String id;
  final String amenity;
  final String residentName;
  final String residentApartment;
  final String residentId;
  final DateTime date;
  final String timeSlot;
  final String status; // 'pending', 'confirmed', 'cancelled'
  final String condominiumId;

  Reservation({
    required this.id,
    required this.amenity,
    required this.residentName,
    required this.residentApartment,
    required this.residentId,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.condominiumId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amenity': amenity,
      'residentName': residentName,
      'residentApartment': residentApartment,
      'residentId': residentId,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'status': status,
      'condominiumId': condominiumId,
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'] as String,
      amenity: map['amenity'] as String,
      residentName: map['residentName'] as String,
      residentApartment: map['residentApartment'] as String,
      residentId: map['residentId'] as String,
      date: DateTime.parse(map['date'] as String),
      timeSlot: map['timeSlot'] as String,
      status: map['status'] as String,
      condominiumId: map['condominiumId'] as String,
    );
  }

  // Método para obtener el color según el estado
  Color getStatusColor() {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Método para obtener el texto de estado
  String getStatusText() {
    switch (status) {
      case 'confirmed':
        return 'Confirmada';
      case 'pending':
        return 'Pendiente';
      case 'cancelled':
        return 'Cancelada';
      default:
        return 'Desconocido';
    }
  }
}

// Modelo para Actividad (log del sistema)
class Activity {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String type; // 'reservation', 'announcement', 'payment', 'resident'
  final String condominiumId;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.condominiumId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'type': type,
      'condominiumId': condominiumId,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      date: DateTime.parse(map['date'] as String),
      type: map['type'] as String,
      condominiumId: map['condominiumId'] as String,
    );
  }

  // Método para obtener el icono según el tipo
  IconData getIcon() {
    switch (type) {
      case 'reservation':
        return Icons.calendar_today;
      case 'announcement':
        return Icons.announcement;
      case 'payment':
        return Icons.payment;
      case 'resident':
        return Icons.person_add;
      default:
        return Icons.info;
    }
  }

  // Método para obtener el color según el tipo
  Color getColor() {
    switch (type) {
      case 'reservation':
        return Colors.blue;
      case 'announcement':
        return Colors.green;
      case 'payment':
        return Colors.orange;
      case 'resident':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

// Store principal que contiene todos los datos mock
class MockBackendStore extends ChangeNotifier {
  // Datos iniciales mock
  List<Condominium> _condominiums = [];
  List<Resident> _residents = [];
  List<Announcement> _announcements = [];
  List<PaymentReminder> _paymentReminders = [];
  List<Reservation> _reservations = [];
  List<Activity> _activities = [];

  MockBackendStore() {
    _initializeMockData();
  }

  // Inicializar datos mock
  void _initializeMockData() {
    // Condominios
    _condominiums = [
      Condominium(
        id: '1',
        name: 'Torre Central',
        address: 'Av. Principal 123',
        totalResidents: 150,
        imageUrl: '',
      ),
      Condominium(
        id: '2',
        name: 'Residencial Las Palmas',
        address: 'Calle Secundaria 456',
        totalResidents: 80,
        imageUrl: '',
      ),
      Condominium(
        id: '3',
        name: 'Condominio El Mirador',
        address: 'Boulevard Norte 789',
        totalResidents: 120,
        imageUrl: '',
      ),
      Condominium(
        id: '4',
        name: 'Edificio Horizonte',
        address: 'Plaza Central 101',
        totalResidents: 200,
        imageUrl: '',
      ),
    ];

    // Residentes (asignados a condominios específicos)
    _residents = [
      // Condominio 1 - Torre Central
      Resident(
        id: '1',
        name: 'Juan Pérez',
        apartment: 'Apto 301',
        email: 'juan.perez@email.com',
        phone: '+1 234 567 8901',
        condominiumId: '1',
        registrationDate: DateTime.now().subtract(const Duration(days: 365)),
        status: 'active',
      ),
      Resident(
        id: '2',
        name: 'María González',
        apartment: 'Apto 402',
        email: 'maria.gonzalez@email.com',
        phone: '+1 234 567 8902',
        condominiumId: '1',
        registrationDate: DateTime.now().subtract(const Duration(days: 200)),
        status: 'active',
      ),
      // Condominio 2 - Residencial Las Palmas
      Resident(
        id: '3',
        name: 'Carlos Rodríguez',
        apartment: 'Apto 205',
        email: 'carlos.rodriguez@email.com',
        phone: '+1 234 567 8903',
        condominiumId: '2',
        registrationDate: DateTime.now().subtract(const Duration(days: 150)),
        status: 'active',
      ),
      Resident(
        id: '4',
        name: 'Ana Martínez',
        apartment: 'Apto 101',
        email: 'ana.martinez@email.com',
        phone: '+1 234 567 8904',
        condominiumId: '2',
        registrationDate: DateTime.now().subtract(const Duration(days: 50)),
        status: 'pending',
      ),
      // Condominio 3 - Condominio El Mirador
      Resident(
        id: '5',
        name: 'Luis Fernández',
        apartment: 'Apto 303',
        email: 'luis.fernandez@email.com',
        phone: '+1 234 567 8905',
        condominiumId: '3',
        registrationDate: DateTime.now().subtract(const Duration(days: 400)),
        status: 'inactive',
      ),
    ];

    // Anuncios
    _announcements = [
      Announcement(
        id: '1',
        title: 'Mantenimiento de ascensores',
        content:
            'Se realizará mantenimiento preventivo en todos los ascensores del edificio durante el fin de semana.',
        date: DateTime.now().subtract(const Duration(days: 1)),
        author: 'Administrador',
        condominiumId: '1',
        isPublished: true,
      ),
      Announcement(
        id: '2',
        title: 'Reunión de condominio',
        content:
            'Se convoca a reunión extraordinaria para discutir temas importantes del condominio.',
        date: DateTime.now().subtract(const Duration(days: 3)),
        author: 'Administrador',
        condominiumId: '2',
        isPublished: true,
      ),
    ];

    // Recordatorios de pago
    _paymentReminders = [
      PaymentReminder(
        id: '1',
        title: 'Recordatorio de pago mensual',
        message:
            'Recuerda realizar el pago de mantenimiento correspondiente al mes actual.',
        date: DateTime.now().subtract(const Duration(days: 5)),
        priority: 'high',
        condominiumId: '1',
        sent: true,
      ),
      PaymentReminder(
        id: '2',
        title: 'Pago vencido',
        message:
            'Tu pago de mantenimiento está vencido. Por favor regulariza tu situación.',
        date: DateTime.now().subtract(const Duration(days: 15)),
        priority: 'high',
        condominiumId: '2',
        sent: true,
        residentId: '3',
      ),
    ];

    // Reservas
    _reservations = [
      Reservation(
        id: '1',
        amenity: 'Sala de eventos',
        residentName: 'Juan Pérez',
        residentApartment: 'Apto 301',
        residentId: '1',
        date: DateTime.now().add(const Duration(days: 1)),
        timeSlot: '14:00 - 16:00',
        status: 'confirmed',
        condominiumId: '1',
      ),
      Reservation(
        id: '2',
        amenity: 'Gimnasio',
        residentName: 'María González',
        residentApartment: 'Apto 402',
        residentId: '2',
        date: DateTime.now().add(const Duration(days: 2)),
        timeSlot: '18:00 - 20:00',
        status: 'pending',
        condominiumId: '1',
      ),
    ];

    // Actividades
    _activities = [
      Activity(
        id: '1',
        title: 'Nueva reserva',
        description: 'Juan Pérez reservó la sala de eventos para mañana',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        type: 'reservation',
        condominiumId: '1',
      ),
      Activity(
        id: '2',
        title: 'Anuncio publicado',
        description: 'Se publicó un nuevo anuncio sobre mantenimiento',
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: 'announcement',
        condominiumId: '1',
      ),
      Activity(
        id: '3',
        title: 'Pago vencido',
        description: '3 residentes con pagos pendientes',
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: 'payment',
        condominiumId: '1',
      ),
      Activity(
        id: '4',
        title: 'Nuevo residente',
        description: 'María González se registró en el sistema',
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: 'resident',
        condominiumId: '1',
      ),
    ];
  }

  // Getters para todos los datos
  List<Condominium> get condominiums => _condominiums;
  List<Resident> get residents => _residents;
  List<Announcement> get announcements => _announcements;
  List<PaymentReminder> get paymentReminders => _paymentReminders;
  List<Reservation> get reservations => _reservations;
  List<Activity> get activities => _activities;

  // Métodos para obtener datos filtrados por condominio
  List<Resident> getResidentsByCondominium(String condominiumId) {
    return _residents
        .where((resident) => resident.condominiumId == condominiumId)
        .toList();
  }

  List<Announcement> getAnnouncementsByCondominium(String condominiumId) {
    return _announcements
        .where((announcement) => announcement.condominiumId == condominiumId)
        .toList();
  }

  List<PaymentReminder> getPaymentRemindersByCondominium(String condominiumId) {
    return _paymentReminders
        .where((reminder) => reminder.condominiumId == condominiumId)
        .toList();
  }

  List<Reservation> getReservationsByCondominium(String condominiumId) {
    return _reservations
        .where((reservation) => reservation.condominiumId == condominiumId)
        .toList();
  }

  List<Activity> getActivitiesByCondominium(String condominiumId) {
    return _activities
        .where((activity) => activity.condominiumId == condominiumId)
        .toList();
  }

  // Métodos para agregar nuevos datos
  void addAnnouncement(Announcement announcement) {
    _announcements.insert(0, announcement);

    // Agregar actividad relacionada
    _activities.insert(
      0,
      Activity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Nuevo anuncio: ${announcement.title}',
        description: 'Se publicó un nuevo anuncio en el condominio',
        date: DateTime.now(),
        type: 'announcement',
        condominiumId: announcement.condominiumId,
      ),
    );

    notifyListeners();
  }

  void addPaymentReminder(PaymentReminder reminder) {
    _paymentReminders.insert(0, reminder);

    // Agregar actividad relacionada
    _activities.insert(
      0,
      Activity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Recordatorio de pago enviado',
        description:
            reminder.residentId != null
                ? 'Recordatorio enviado a residente específico'
                : 'Recordatorio enviado a todos los residentes',
        date: DateTime.now(),
        type: 'payment',
        condominiumId: reminder.condominiumId,
      ),
    );

    notifyListeners();
  }

  void addReservation(Reservation reservation) {
    _reservations.insert(0, reservation);

    // Agregar actividad relacionada
    _activities.insert(
      0,
      Activity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Nueva reserva: ${reservation.amenity}',
        description:
            '${reservation.residentName} reservó ${reservation.amenity}',
        date: DateTime.now(),
        type: 'reservation',
        condominiumId: reservation.condominiumId,
      ),
    );

    notifyListeners();
  }

  void addResident(Resident resident) {
    _residents.insert(0, resident);

    // Agregar actividad relacionada
    _activities.insert(
      0,
      Activity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Nuevo residente registrado',
        description: '${resident.name} se registró en el sistema',
        date: DateTime.now(),
        type: 'resident',
        condominiumId: resident.condominiumId,
      ),
    );

    notifyListeners();
  }

  // Métodos para actualizar datos
  void updateReservationStatus(String reservationId, String newStatus) {
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      final oldReservation = _reservations[index];
      _reservations[index] = Reservation(
        id: oldReservation.id,
        amenity: oldReservation.amenity,
        residentName: oldReservation.residentName,
        residentApartment: oldReservation.residentApartment,
        residentId: oldReservation.residentId,
        date: oldReservation.date,
        timeSlot: oldReservation.timeSlot,
        status: newStatus,
        condominiumId: oldReservation.condominiumId,
      );

      // Agregar actividad relacionada
      _activities.insert(
        0,
        Activity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title:
              'Reserva ${newStatus == 'confirmed' ? 'confirmada' : 'cancelada'}',
          description:
              'Reserva de ${oldReservation.amenity} ${newStatus == 'confirmed' ? 'confirmada' : 'cancelada'}',
          date: DateTime.now(),
          type: 'reservation',
          condominiumId: oldReservation.condominiumId,
        ),
      );

      notifyListeners();
    }
  }

  void updateResidentStatus(String residentId, String newStatus) {
    final index = _residents.indexWhere((r) => r.id == residentId);
    if (index != -1) {
      final oldResident = _residents[index];
      _residents[index] = Resident(
        id: oldResident.id,
        name: oldResident.name,
        apartment: oldResident.apartment,
        email: oldResident.email,
        phone: oldResident.phone,
        condominiumId: oldResident.condominiumId,
        registrationDate: oldResident.registrationDate,
        status: newStatus,
      );

      notifyListeners();
    }
  }

  void deleteAnnouncement(String announcementId) {
    _announcements.removeWhere((a) => a.id == announcementId);
    notifyListeners();
  }

  // Método para buscar residentes
  List<Resident> searchResidents(String query, String condominiumId) {
    final filteredResidents = getResidentsByCondominium(condominiumId);
    if (query.isEmpty) return filteredResidents;

    final lowercaseQuery = query.toLowerCase();
    return filteredResidents.where((resident) {
      return resident.name.toLowerCase().contains(lowercaseQuery) ||
          resident.apartment.toLowerCase().contains(lowercaseQuery) ||
          resident.email.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Método para buscar condominios
  List<Condominium> searchCondominiums(String query) {
    if (query.isEmpty) return _condominiums;

    final lowercaseQuery = query.toLowerCase();
    return _condominiums.where((condominium) {
      return condominium.name.toLowerCase().contains(lowercaseQuery) ||
          condominium.address.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Método para obtener un condominio por ID
  Condominium? getCondominiumById(String id) {
    return _condominiums.firstWhere((condo) => condo.id == id);
  }

  // Método para obtener un residente por ID
  Resident? getResidentById(String id) {
    return _residents.firstWhere((resident) => resident.id == id);
  }

  // Método para obtener un anuncio por ID
  Announcement? getAnnouncementById(String id) {
    return _announcements.firstWhere((announcement) => announcement.id == id);
  }

  // Método para obtener un recordatorio por ID
  PaymentReminder? getPaymentReminderById(String id) {
    return _paymentReminders.firstWhere((reminder) => reminder.id == id);
  }

  // Método para obtener una reserva por ID
  Reservation? getReservationById(String id) {
    return _reservations.firstWhere((reservation) => reservation.id == id);
  }

  // Método para obtener una actividad por ID
  Activity? getActivityById(String id) {
    return _activities.firstWhere((activity) => activity.id == id);
  }
}
