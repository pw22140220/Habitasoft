import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin_state.dart';

class AdminCondominiumsScreen extends StatefulWidget {
  const AdminCondominiumsScreen({super.key});

  @override
  State<AdminCondominiumsScreen> createState() =>
      _AdminCondominiumsScreenState();
}

class _AdminCondominiumsScreenState extends State<AdminCondominiumsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminState = Provider.of<AdminState>(context);
    final allCondominiums = adminState.condominios;
    final selectedCondominium = adminState.selectedCondominio;

    final filteredCondominiums =
        _searchQuery.isEmpty
            ? allCondominiums
            : adminState.searchCondominiums(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Condominios'),
        backgroundColor: Colors.green[700],
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar condominio...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey[600]),
                  suffixIcon:
                      _searchQuery.isNotEmpty
                          ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[600]),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                          : Icon(Icons.filter_list, color: Colors.grey[600]),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),

          if (selectedCondominium != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Condominio actual',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          selectedCondominium.nombre,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          if (adminState.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredCondominiums.length,
                itemBuilder: (context, index) {
                  final condominio = filteredCondominiums[index];
                  final isSelected = selectedCondominium?.id == condominio.id;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green[50] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color:
                            isSelected ? Colors.green[200]! : Colors.grey[200]!,
                      ),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.green[700] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.apartment,
                          color: isSelected ? Colors.white : Colors.grey[600],
                        ),
                      ),
                      title: Text(
                        condominio.nombre,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              isSelected ? Colors.green[800] : Colors.grey[800],
                        ),
                      ),
                      subtitle: Text(
                        condominio.direccion,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected)
                            Icon(Icons.check_circle, color: Colors.green[700])
                          else
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          IconButton(
                            icon: Icon(
                              Icons.edit_outlined,
                              color: Colors.blue[400],
                              size: 20,
                            ),
                            onPressed:
                                () => _showEditCondominiumDialog(
                                  context,
                                  condominio,
                                ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red[400],
                              size: 20,
                            ),
                            onPressed:
                                () => _confirmarEliminar(context, condominio),
                          ),
                        ],
                      ),
                      onTap: () {
                        adminState.selectCondominium(condominio);
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _showAddCondominiumDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Agregar nuevo condominio',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminar(BuildContext context, dynamic condominio) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Eliminar condominio'),
            content: Text(
              '¿Estás seguro de eliminar "${condominio.nombre}"?\nEsta acción no se puede deshacer.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  final adminState = Provider.of<AdminState>(
                    context,
                    listen: false,
                  );
                  final exito = await adminState.eliminarCondominio(
                    condominio.id,
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          exito
                              ? 'Condominio eliminado exitosamente'
                              : 'Error al eliminar condominio',
                        ),
                        backgroundColor: exito ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                ),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showEditCondominiumDialog(BuildContext context, dynamic condominio) {
    final nombreCtrl = TextEditingController(text: condominio.nombre);
    final direccionCtrl = TextEditingController(text: condominio.direccion);

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Editar Condominio'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del condominio',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: direccionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Dirección',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final nombre = nombreCtrl.text.trim();
                  final direccion = direccionCtrl.text.trim();
                  if (nombre.isEmpty || direccion.isEmpty) return;

                  Navigator.of(ctx).pop();
                  final adminState = Provider.of<AdminState>(
                    context,
                    listen: false,
                  );
                  final exito = await adminState.actualizarCondominio(
                    condominio.id,
                    nombre,
                    direccion,
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          exito
                              ? 'Condominio actualizado exitosamente'
                              : 'Error al actualizar condominio',
                        ),
                        backgroundColor: exito ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                ),
                child: const Text(
                  'Guardar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showAddCondominiumDialog(BuildContext context) {
    final nombreCtrl = TextEditingController();
    final direccionCtrl = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Agregar Condominio'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del condominio',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: direccionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Dirección',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final nombre = nombreCtrl.text.trim();
                  final direccion = direccionCtrl.text.trim();
                  if (nombre.isEmpty || direccion.isEmpty) return;

                  Navigator.of(ctx).pop();
                  final adminState = Provider.of<AdminState>(
                    context,
                    listen: false,
                  );
                  final exito = await adminState.agregarCondominio(
                    nombre,
                    direccion,
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          exito
                              ? 'Condominio agregado exitosamente'
                              : 'Error al agregar condominio',
                        ),
                        backgroundColor: exito ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                ),
                child: const Text(
                  'Agregar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
