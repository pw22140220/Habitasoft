import 'package:flutter/material.dart';

// Pantalla de configuración de notificaciones del administrador
class AdminNotificationsSettingsScreen extends StatefulWidget {
  const AdminNotificationsSettingsScreen({super.key});

  @override
  State<AdminNotificationsSettingsScreen> createState() =>
      _AdminNotificationsSettingsScreenState();
}

class _AdminNotificationsSettingsScreenState
    extends State<AdminNotificationsSettingsScreen> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  bool _newResidentAlerts = true;
  bool _paymentReminderAlerts = true;
  bool _maintenanceAlerts = true;
  bool _securityAlerts = true;
  bool _meetingAlerts = true;
  bool _quietHoursEnabled = false;
  TimeOfDay _quietStartTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietEndTime = const TimeOfDay(hour: 8, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: Colors.green[700],
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Canales de notificación
            _buildSectionTitle('Canales de notificación'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildNotificationChannel(
                    title: 'Correo electrónico',
                    subtitle: 'Recibir notificaciones por email',
                    value: _emailNotifications,
                    icon: Icons.email,
                    color: Colors.red,
                    onChanged: (value) {
                      setState(() {
                        _emailNotifications = value!;
                      });
                    },
                  ),
                  const Divider(height: 16),
                  _buildNotificationChannel(
                    title: 'Notificaciones push',
                    subtitle: 'Recibir notificaciones en el dispositivo',
                    value: _pushNotifications,
                    icon: Icons.notifications,
                    color: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        _pushNotifications = value!;
                      });
                    },
                  ),
                  const Divider(height: 16),
                  _buildNotificationChannel(
                    title: 'Mensajes SMS',
                    subtitle: 'Recibir notificaciones por SMS',
                    value: _smsNotifications,
                    icon: Icons.sms,
                    color: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        _smsNotifications = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tipos de alertas
            _buildSectionTitle('Tipos de alertas'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildAlertType(
                    title: 'Nuevos residentes',
                    subtitle: 'Cuando se registra un nuevo residente',
                    value: _newResidentAlerts,
                    onChanged: (value) {
                      setState(() {
                        _newResidentAlerts = value!;
                      });
                    },
                  ),
                  const Divider(height: 12),
                  _buildAlertType(
                    title: 'Recordatorios de pago',
                    subtitle: 'Alertas sobre pagos pendientes',
                    value: _paymentReminderAlerts,
                    onChanged: (value) {
                      setState(() {
                        _paymentReminderAlerts = value!;
                      });
                    },
                  ),
                  const Divider(height: 12),
                  _buildAlertType(
                    title: 'Mantenimiento',
                    subtitle: 'Alertas sobre mantenimiento programado',
                    value: _maintenanceAlerts,
                    onChanged: (value) {
                      setState(() {
                        _maintenanceAlerts = value!;
                      });
                    },
                  ),
                  const Divider(height: 12),
                  _buildAlertType(
                    title: 'Seguridad',
                    subtitle: 'Alertas de seguridad e incidentes',
                    value: _securityAlerts,
                    onChanged: (value) {
                      setState(() {
                        _securityAlerts = value!;
                      });
                    },
                  ),
                  const Divider(height: 12),
                  _buildAlertType(
                    title: 'Reuniones',
                    subtitle: 'Recordatorios de reuniones de condominio',
                    value: _meetingAlerts,
                    onChanged: (value) {
                      setState(() {
                        _meetingAlerts = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Horarios silenciosos
            _buildSectionTitle('Horarios silenciosos'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildToggleOption(
                    title: 'Activar horarios silenciosos',
                    subtitle: 'No recibir notificaciones durante ciertas horas',
                    value: _quietHoursEnabled,
                    onChanged: (value) {
                      setState(() {
                        _quietHoursEnabled = value!;
                      });
                    },
                  ),
                  if (_quietHoursEnabled) ...[
                    const SizedBox(height: 16),
                    _buildTimeSelector(
                      label: 'Hora de inicio',
                      time: _quietStartTime,
                      onTap: () => _selectStartTime(context),
                    ),
                    const SizedBox(height: 12),
                    _buildTimeSelector(
                      label: 'Hora de fin',
                      time: _quietEndTime,
                      onTap: () => _selectEndTime(context),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No recibirás notificaciones entre ${_quietStartTime.format(context)} y ${_quietEndTime.format(context)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Frecuencia de resúmenes
            _buildSectionTitle('Resúmenes'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen diario',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Recibe un resumen diario de actividades a las 8:00 PM',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Resumen semanal',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Recibe un resumen semanal los lunes a las 9:00 AM',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Botón de guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Guardar configuración'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Método para construir título de sección
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  // Método para construir canal de notificación
  Widget _buildNotificationChannel({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required Color color,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.green[700],
        ),
      ],
    );
  }

  // Método para construir tipo de alerta
  Widget _buildAlertType({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.green[700],
        ),
      ],
    );
  }

  // Método para construir opción de toggle
  Widget _buildToggleOption({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.green[700],
        ),
      ],
    );
  }

  // Método para construir selector de tiempo
  Widget _buildTimeSelector({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  time.format(context),
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Método para seleccionar hora de inicio
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _quietStartTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Colors.green[700]!),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _quietStartTime) {
      setState(() {
        _quietStartTime = picked;
      });
    }
  }

  // Método para seleccionar hora de fin
  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _quietEndTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Colors.green[700]!),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _quietEndTime) {
      setState(() {
        _quietEndTime = picked;
      });
    }
  }

  // Método para guardar configuración
  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración de notificaciones guardada'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }
}
