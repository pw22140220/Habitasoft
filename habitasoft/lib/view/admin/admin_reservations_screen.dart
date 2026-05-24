import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/amenidad_model.dart';
import 'admin_state.dart';
import 'admin_condominiums_screen.dart';

class AdminReservationsScreen extends StatefulWidget {
  const AdminReservationsScreen({super.key});

  @override
  State<AdminReservationsScreen> createState() =>
      _AdminReservationsScreenState();
}

class _AdminReservationsScreenState extends State<AdminReservationsScreen> {
  final _nameController = TextEditingController();
  final _capacityController = TextEditingController();
  int? _lastCondominioId;

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recargarSiCambioCondominio();
    });
  }

  void _recargarSiCambioCondominio() {
    if (!mounted) return;
    final adminState = context.read<AdminState>();
    final condominioId = adminState.selectedCondominio?.id;
    if (condominioId != null && condominioId != _lastCondominioId) {
      _lastCondominioId = condominioId;
      adminState.cargarAmenidades(condominioId: condominioId);
    }
  }

  void _recargarForzada(AdminState adminState) {
    final condominioId = adminState.selectedCondominio?.id;
    if (condominioId != null) {
      _lastCondominioId = condominioId;
      adminState.cargarAmenidades(condominioId: condominioId);
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
        title: const Text('Amenidades'),
        backgroundColor: Colors.green[700],
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!adminState.hasSelectedCondominium) {
            _showNoCondominiumDialog(context);
          } else {
            _nameController.clear();
            _capacityController.clear();
            _showAmenidadFormDialog(context, adminState, null);
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
                      'Amenidades de: ${selectedCondominium.nombre}',
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
                      'Selecciona un condominio para ver amenidades',
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
                  adminState.amenidades.isEmpty
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.place_outlined,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No hay amenidades',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Agrega la primera amenidad',
                              style: TextStyle(
                                fontSize: 14,
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
                          itemCount: adminState.amenidades.length,
                          itemBuilder: (context, index) {
                            final amenidad = adminState.amenidades[index];
                            return _buildAmenidadCard(amenidad, adminState);
                          },
                        ),
                      ),
            ),
        ],
      ),
    );
  }

  Widget _buildAmenidadCard(Amenidad amenidad, AdminState adminState) {
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
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.place, color: Colors.purple),
        ),
        title: Text(
          amenidad.nombre,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.people, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  amenidad.capacidadMaxima != null
                      ? 'Capacidad: ${amenidad.capacidadMaxima} personas'
                      : 'Sin límite de capacidad',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _nameController.text = amenidad.nombre;
              _capacityController.text =
                  amenidad.capacidadMaxima?.toString() ?? '';
              _showAmenidadFormDialog(context, adminState, amenidad);
            } else if (value == 'delete') {
              _confirmDelete(context, adminState, amenidad);
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Editar')),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Eliminar', style: TextStyle(color: Colors.red)),
                ),
              ],
        ),
        onTap: () => _showAmenidadDetail(context, amenidad),
      ),
    );
  }

  void _showAmenidadFormDialog(
    BuildContext context,
    AdminState adminState,
    Amenidad? amenidadExistente,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                amenidadExistente != null
                    ? 'Editar Amenidad'
                    : 'Nueva Amenidad',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la amenidad',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _capacityController,
                      decoration: const InputDecoration(
                        labelText: 'Capacidad máxima (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
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
                    if (_nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El nombre es obligatorio'),
                        ),
                      );
                      return;
                    }

                    final condominioId = adminState.selectedCondominio!.id;
                    final capacidad =
                        _capacityController.text.isNotEmpty
                            ? int.tryParse(_capacityController.text)
                            : null;
                    bool exito;

                    if (amenidadExistente != null) {
                      exito = await adminState.actualizarAmenidad(
                        amenidadExistente.id,
                        _nameController.text,
                        condominioId,
                        capacidad,
                      );
                    } else {
                      exito = await adminState.crearAmenidad(
                        _nameController.text,
                        condominioId,
                        capacidad,
                      );
                    }

                    if (!mounted) return;
                    Navigator.of(context).pop();
                    _nameController.clear();
                    _capacityController.clear();

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          exito
                              ? (amenidadExistente != null
                                  ? 'Amenidad actualizada'
                                  : 'Amenidad creada')
                              : 'Error al guardar amenidad',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                  ),
                  child: Text(
                    amenidadExistente != null
                        ? 'Guardar Cambios'
                        : 'Crear Amenidad',
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
    Amenidad amenidad,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Amenidad'),
          content: Text(
            '¿Estás seguro de eliminar "${amenidad.nombre}"?\n\n'
            'Las reservaciones asociadas también se eliminarán.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final exito = await adminState.eliminarAmenidad(amenidad.id);
                if (!mounted) return;
                Navigator.of(context).pop();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      exito
                          ? 'Amenidad eliminada'
                          : 'Error al eliminar amenidad',
                    ),
                  ),
                );
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

  void _showAmenidadDetail(BuildContext context, Amenidad amenidad) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(amenidad.nombre),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.place,
                      size: 40,
                      color: Colors.purple,
                    ),
                  ),
                ),
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
                          Icon(Icons.tag, color: Colors.grey[600], size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'ID: ${amenidad.id}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.people, color: Colors.grey[600], size: 16),
                          const SizedBox(width: 8),
                          Text(
                            amenidad.capacidadMaxima != null
                                ? 'Capacidad: ${amenidad.capacidadMaxima} personas'
                                : 'Sin límite de capacidad',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.apartment,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Condominio ID: ${amenidad.condominioId}',
                            style: TextStyle(color: Colors.grey[600]),
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
            'Debes seleccionar un condominio para gestionar amenidades.',
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
