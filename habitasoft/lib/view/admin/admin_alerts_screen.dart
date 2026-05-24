import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/alerta_model.dart';
import 'admin_state.dart';
import 'admin_condominiums_screen.dart';

class AdminAlertsScreen extends StatefulWidget {
  const AdminAlertsScreen({super.key});

  @override
  State<AdminAlertsScreen> createState() => _AdminAlertsScreenState();
}

class _AdminAlertsScreenState extends State<AdminAlertsScreen> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedPriority = 'MEDIA';
  DateTime? _selectedExpiration;
  int? _lastCondominioId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recargarSiCambioCondominio();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _recargarSiCambioCondominio() {
    if (!mounted) return;
    final adminState = context.read<AdminState>();
    final condominioId = adminState.selectedCondominio?.id;
    if (condominioId != null && condominioId != _lastCondominioId) {
      _lastCondominioId = condominioId;
      adminState.cargarAlertas(condominioId: condominioId);
    }
  }

  void _recargarForzada(AdminState adminState) {
    final condominioId = adminState.selectedCondominio?.id;
    if (condominioId != null) {
      _lastCondominioId = condominioId;
      adminState.cargarAlertas(condominioId: condominioId);
    }
  }

  String _prioridadToBackend(String prioridad) {
    switch (prioridad) {
      case 'ALTA':
        return 'ALTA';
      case 'MEDIA':
        return 'MEDIA';
      case 'BAJA':
        return 'BAJA';
      default:
        return 'MEDIA';
    }
  }

  String _prioridadToLabel(String prioridad) {
    switch (prioridad) {
      case 'ALTA':
        return 'Alta';
      case 'MEDIA':
        return 'Media';
      case 'BAJA':
        return 'Baja';
      default:
        return prioridad;
    }
  }

  String _formatFecha(String? fecha) {
    if (fecha == null || fecha.length < 10) return '';
    final parts = fecha.substring(0, 10).split('-');
    if (parts.length != 3) return fecha.substring(0, 10);
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  String _formatDateTime(String? fecha) {
    if (fecha == null || fecha.length < 16) return '';
    final dateParts = fecha.substring(0, 10).split('-');
    if (dateParts.length != 3) return fecha.substring(0, 10);
    final time = fecha.substring(11, 16);
    return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]} $time';
  }

  Color _prioridadColor(String prioridad) {
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

  @override
  Widget build(BuildContext context) {
    final adminState = context.watch<AdminState>();
    final selectedCondominium = adminState.selectedCondominio;

    final currentId = selectedCondominium?.id;
    if (currentId != null && currentId != _lastCondominioId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _recargarSiCambioCondominio();
      });
    }

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
            _titleController.clear();
            _messageController.clear();
            _selectedPriority = 'MEDIA';
            _selectedExpiration = null;
            _showAlertFormDialog(context, adminState, null);
          }
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
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
                      'Alertas de: ${selectedCondominium.nombre}',
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
                      'Selecciona un condominio para ver alertas',
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
          if (adminState.isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Expanded(
              child:
                  adminState.alertas.isEmpty
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
                              'No hay alertas',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      : RefreshIndicator(
                        onRefresh: () async => _recargarForzada(adminState),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: adminState.alertas.length,
                          itemBuilder: (context, index) {
                            final alerta = adminState.alertas[index];
                            return _buildAlertCard(alerta, adminState);
                          },
                        ),
                      ),
            ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(Alerta alerta, AdminState adminState) {
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
            color: _prioridadColor(alerta.prioridad).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.notifications,
            color: _prioridadColor(alerta.prioridad),
          ),
        ),
        title: Text(
          alerta.titulo,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              alerta.mensaje,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _prioridadColor(alerta.prioridad).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _prioridadToLabel(alerta.prioridad),
                      style: TextStyle(
                        fontSize: 10,
                        color: _prioridadColor(alerta.prioridad),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    _formatFecha(alerta.fechaCreacion),
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                  if (alerta.fechaExpiracion != null) ...[
                    const SizedBox(width: 6),
                    Icon(Icons.schedule, size: 12, color: Colors.red[300]),
                    const SizedBox(width: 4),
                    Text(
                      _formatFecha(alerta.fechaExpiracion),
                      style: TextStyle(fontSize: 10, color: Colors.red[300]),
                    ),
                  ],
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _titleController.text = alerta.titulo;
              _messageController.text = alerta.mensaje;
              _selectedPriority = alerta.prioridad;
              _selectedExpiration =
                  alerta.fechaExpiracion != null
                      ? DateTime.tryParse(alerta.fechaExpiracion!)
                      : null;
              _showAlertFormDialog(context, adminState, alerta);
            } else if (value == 'delete') {
              _confirmDelete(context, adminState, alerta);
            } else if (value == 'view') {
              _showAlertDetail(context, alerta);
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(value: 'view', child: Text('Ver detalle')),
                const PopupMenuItem(value: 'edit', child: Text('Editar')),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Eliminar', style: TextStyle(color: Colors.red)),
                ),
              ],
        ),
        onTap: () => _showAlertDetail(context, alerta),
      ),
    );
  }

  void _showAlertFormDialog(
    BuildContext context,
    AdminState adminState,
    Alerta? alertaExistente,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                alertaExistente != null ? 'Editar Alerta' : 'Nueva Alerta',
              ),
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
                        DropdownMenuItem(value: 'ALTA', child: Text('Alta')),
                        DropdownMenuItem(value: 'MEDIA', child: Text('Media')),
                        DropdownMenuItem(value: 'BAJA', child: Text('Baja')),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedPriority = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate:
                              _selectedExpiration ??
                              DateTime.now().add(const Duration(days: 7)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (date != null) {
                          setDialogState(() {
                            _selectedExpiration = date;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Fecha de expiración (opcional)',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_month),
                        ),
                        child: Text(
                          _selectedExpiration != null
                              ? '${_selectedExpiration!.day.toString().padLeft(2, '0')}/${_selectedExpiration!.month.toString().padLeft(2, '0')}/${_selectedExpiration!.year}'
                              : 'Sin expiración',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_titleController.text.isEmpty ||
                        _messageController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Completa todos los campos'),
                        ),
                      );
                      return;
                    }

                    final condominioId = adminState.selectedCondominio!.id;
                    final prioridad = _prioridadToBackend(_selectedPriority);
                    bool exito;

                    final expiracionStr =
                        _selectedExpiration != null
                            ? '${_selectedExpiration!.year.toString().padLeft(4, '0')}-${_selectedExpiration!.month.toString().padLeft(2, '0')}-${_selectedExpiration!.day.toString().padLeft(2, '0')}T23:59:59'
                            : null;

                    if (alertaExistente != null) {
                      exito = await adminState.actualizarAlerta(
                        alertaExistente.id,
                        _titleController.text,
                        _messageController.text,
                        prioridad,
                        condominioId,
                        fechaExpiracion: expiracionStr,
                      );
                    } else {
                      exito = await adminState.crearAlerta(
                        _titleController.text,
                        _messageController.text,
                        prioridad,
                        condominioId,
                        1,
                        fechaExpiracion: expiracionStr,
                      );
                    }

                    if (!mounted) return;
                    Navigator.of(context).pop();
                    _titleController.clear();
                    _messageController.clear();
                    _selectedPriority = 'MEDIA';
                    _selectedExpiration = null;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          exito
                              ? (alertaExistente != null
                                  ? 'Alerta actualizada'
                                  : 'Alerta creada')
                              : 'Error al guardar alerta',
                        ),
                      ),
                    );

                    _recargarForzada(adminState);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                  ),
                  child: Text(
                    alertaExistente != null
                        ? 'Guardar Cambios'
                        : 'Crear Alerta',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    AdminState adminState,
    Alerta alerta,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Alerta'),
          content: Text(
            '¿Estás seguro de eliminar la alerta "${alerta.titulo}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final exito = await adminState.eliminarAlerta(alerta.id);
                if (!mounted) return;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      exito ? 'Alerta eliminada' : 'Error al eliminar alerta',
                    ),
                  ),
                );
                _recargarForzada(adminState);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDetail(BuildContext context, Alerta alerta) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(alerta.titulo),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(alerta.mensaje, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.priority_high,
                            color: _prioridadColor(alerta.prioridad),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Prioridad: ${_prioridadToLabel(alerta.prioridad)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: _prioridadColor(alerta.prioridad),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Creada: ${_formatDateTime(alerta.fechaCreacion)}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      if (alerta.fechaExpiracion != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              color: Colors.red[300],
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Expira: ${_formatDateTime(alerta.fechaExpiracion)}',
                              style: TextStyle(color: Colors.red[300]),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            alerta.activa ? Icons.check_circle : Icons.cancel,
                            color: alerta.activa ? Colors.green : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            alerta.activa
                                ? 'Estado: Activa'
                                : 'Estado: Inactiva',
                            style: TextStyle(
                              color: alerta.activa ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showNoCondominiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Condominio no seleccionado'),
          content: const Text(
            'Debes seleccionar un condominio para gestionar alertas.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
}
