import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin_state.dart';
import 'admin_condominiums_screen.dart';

// Modelo para representar una alerta
class Alert {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final String priority; // 'high', 'medium', 'low'
  final bool sent;

  Alert({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.priority,
    required this.sent,
  });

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

// Pantalla para gestionar alertas del administrador
class AdminAlertsScreen extends StatefulWidget {
  const AdminAlertsScreen({super.key});

  @override
  State<AdminAlertsScreen> createState() => _AdminAlertsScreenState();
}

class _AdminAlertsScreenState extends State<AdminAlertsScreen> {
  // Mock data para alertas
  final List<Alert> _alerts = [
    Alert(
      id: '1',
      title: 'Mantenimiento programado',
      message:
          'El próximo sábado se realizará mantenimiento en el ascensor principal',
      date: DateTime.now().subtract(const Duration(days: 1)),
      priority: 'high',
      sent: true,
    ),
    Alert(
      id: '2',
      title: 'Reunión de condominio',
      message: 'Se convoca a reunión extraordinaria el próximo viernes',
      date: DateTime.now().subtract(const Duration(days: 3)),
      priority: 'medium',
      sent: true,
    ),
    Alert(
      id: '3',
      title: 'Corte de agua',
      message: 'Habrá corte de agua programado para mantenimiento',
      date: DateTime.now().subtract(const Duration(days: 5)),
      priority: 'high',
      sent: true,
    ),
    Alert(
      id: '4',
      title: 'Nuevas reglas de estacionamiento',
      message: 'Se implementarán nuevas reglas a partir del próximo mes',
      date: DateTime.now().subtract(const Duration(days: 7)),
      priority: 'low',
      sent: true,
    ),
  ];

  // Controladores para el formulario
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedPriority = 'medium';

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminState = Provider.of<AdminState>(context);
    final selectedCondominium = adminState.selectedCondominium;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas'),
        backgroundColor: Colors.green[700],
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!adminState.hasSelectedCondominium) {
            _showNoCondominiumDialog(context);
          } else {
            _showNewAlertDialog(context);
          }
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Indicador de condominio seleccionado
          if (selectedCondominium != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                border: Border(bottom: BorderSide(color: Colors.green[100]!)),
              ),
              child: Row(
                children: [
                  Icon(Icons.apartment, color: Colors.green[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Enviando alertas a: ${selectedCondominium.name}',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AdminCondominiumsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Cambiar',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                border: Border(bottom: BorderSide(color: Colors.orange[100]!)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Selecciona un condominio para enviar alertas',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AdminCondominiumsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Seleccionar',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Lista de alertas
          Expanded(
            child:
                _alerts.isEmpty
                    ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No hay alertas enviadas',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _alerts.length,
                      itemBuilder: (context, index) {
                        final alert = _alerts[index];
                        return _buildAlertCard(alert);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  // Método para construir tarjeta de alerta
  Widget _buildAlertCard(Alert alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: alert.getPriorityColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.notifications, color: alert.getPriorityColor()),
        ),
        title: Text(
          alert.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              alert.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: alert.getPriorityColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    alert.getPriorityText(),
                    style: TextStyle(
                      fontSize: 10,
                      color: alert.getPriorityColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  '${alert.date.day}/${alert.date.month}/${alert.date.year}',
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
                const Spacer(),
                Icon(
                  alert.sent ? Icons.check_circle : Icons.error,
                  size: 16,
                  color: alert.sent ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  alert.sent ? 'Enviada' : 'Pendiente',
                  style: TextStyle(
                    fontSize: 10,
                    color: alert.sent ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          // TODO: Ver detalles de la alerta
        },
      ),
    );
  }

  // Método para mostrar diálogo cuando no hay condominio seleccionado
  void _showNoCondominiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Condominio no seleccionado'),
          content: const Text(
            'Debes seleccionar un condominio antes de enviar alertas.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminCondominiumsScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
              ),
              child: const Text(
                'Seleccionar Condominio',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Método para mostrar diálogo de nueva alerta
  void _showNewAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Nueva Alerta'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        labelText: 'Mensaje',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedPriority,
                      decoration: const InputDecoration(
                        labelText: 'Prioridad',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'high', child: Text('Alta')),
                        DropdownMenuItem(value: 'medium', child: Text('Media')),
                        DropdownMenuItem(value: 'low', child: Text('Baja')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedPriority = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isEmpty ||
                        _messageController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Completa todos los campos'),
                        ),
                      );
                      return;
                    }

                    // Crear nueva alerta
                    final newAlert = Alert(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _titleController.text,
                      message: _messageController.text,
                      date: DateTime.now(),
                      priority: _selectedPriority,
                      sent: true,
                    );

                    // Agregar a la lista
                    setState(() {
                      _alerts.insert(0, newAlert);
                    });

                    // Limpiar campos
                    _titleController.clear();
                    _messageController.clear();
                    _selectedPriority = 'medium';

                    // Cerrar diálogo
                    Navigator.of(context).pop();

                    // Mostrar mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Alerta enviada exitosamente'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                  ),
                  child: const Text(
                    'Enviar Alerta',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
