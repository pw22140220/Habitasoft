import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin_state.dart';

class AdminUnitsScreen extends StatefulWidget {
  const AdminUnitsScreen({super.key});

  @override
  State<AdminUnitsScreen> createState() => _AdminUnitsScreenState();
}

class _AdminUnitsScreenState extends State<AdminUnitsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminState>().cargarUnidades();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminState = context.watch<AdminState>();
    final unidades = adminState.unidades;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Unidades'),
        backgroundColor: Colors.green[700],
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUnidadForm(context, adminState, null),
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body:
          unidades.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                onRefresh: () async => adminState.cargarUnidades(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: unidades.length,
                  itemBuilder: (context, index) {
                    final unidad = unidades[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.door_front_door_outlined,
                            color: Colors.teal,
                          ),
                        ),
                        title: Text(
                          unidad.numeroUnidad,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          'ID: ${unidad.id}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: 20,
                              ),
                              onPressed:
                                  () => _showUnidadForm(
                                    context,
                                    adminState,
                                    unidad,
                                  ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed:
                                  () => _confirmDelete(
                                    context,
                                    adminState,
                                    unidad.id,
                                    unidad.numeroUnidad,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.door_front_door_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay unidades',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea la primera unidad',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showUnidadForm(
    BuildContext context,
    AdminState adminState,
    dynamic unidad,
  ) {
    final numeroCtrl = TextEditingController(text: unidad?.numeroUnidad ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(unidad != null ? 'Editar Unidad' : 'Nueva Unidad'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: numeroCtrl,
              decoration: const InputDecoration(
                labelText: 'Número de unidad',
                hintText: 'Ej: A-101, B-2, 102',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.door_front_door_outlined),
              ),
              validator:
                  (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!(formKey.currentState?.validate() ?? false)) return;
                final numero = numeroCtrl.text.trim();
                bool exito;
                if (unidad != null) {
                  exito = await adminState.actualizarUnidad(unidad.id, numero);
                } else {
                  exito = await adminState.crearUnidad(numero);
                }
                if (!mounted) return;
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      exito
                          ? (unidad != null
                              ? 'Unidad actualizada'
                              : 'Unidad creada')
                          : 'Error: ${adminState.error ?? "desconocido"}',
                    ),
                    backgroundColor: exito ? Colors.green : Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
              ),
              child: Text(
                unidad != null ? 'Guardar' : 'Crear',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    AdminState adminState,
    int id,
    String numero,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Eliminar Unidad'),
          content: Text(
            '¿Eliminar la unidad "$numero"?\n\nLos residentes asignados perderán su unidad.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final exito = await adminState.eliminarUnidad(id);
                if (!mounted) return;
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      exito ? 'Unidad eliminada' : 'Error al eliminar unidad',
                    ),
                    backgroundColor: exito ? Colors.green : Colors.red,
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
}
