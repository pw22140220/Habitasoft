import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/usuario_model.dart';
import 'admin_state.dart';
import 'admin_units_screen.dart';

class AdminResidentsScreen extends StatefulWidget {
  const AdminResidentsScreen({super.key});

  @override
  State<AdminResidentsScreen> createState() => _AdminResidentsScreenState();
}

class _AdminResidentsScreenState extends State<AdminResidentsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adminState = context.read<AdminState>();
      if (adminState.hasSelectedCondominium) {
        adminState.cargarUsuarios();
        adminState.cargarUnidades();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminState = context.watch<AdminState>();
    final allUsuarios = adminState.usuarios;
    final usuarios =
        _searchQuery.isEmpty
            ? allUsuarios
            : adminState.searchUsuarios(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        backgroundColor: Colors.green[700],
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.door_front_door_outlined),
            tooltip: 'Gestionar unidades',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AdminUnitsScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!adminState.hasSelectedCondominium) {
            _showNoCondominiumDialog();
          } else {
            adminState.cargarUnidades();
            _showUsuarioForm(context, adminState, null);
          }
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          if (adminState.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child:
                  usuarios.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                        onRefresh: () async => adminState.cargarUsuarios(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: usuarios.length,
                          itemBuilder: (context, index) {
                            return _buildUsuarioCard(
                              usuarios[index],
                              adminState,
                            );
                          },
                        ),
                      ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar por nombre, email o teléfono...',
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.grey[600]),
            suffixIcon:
                _searchQuery.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[600]),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                    : null,
          ),
          onChanged: (v) => setState(() => _searchQuery = v),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay usuarios',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega el primer usuario',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildUsuarioCard(Usuario usuario, AdminState adminState) {
    final Color rolColor =
        usuario.rol == 'guardia' ? Colors.orange : Colors.teal;
    final IconData rolIcon =
        usuario.rol == 'guardia' ? Icons.shield : Icons.person;

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
            color: rolColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              usuario.nombre.isNotEmpty ? usuario.nombre[0].toUpperCase() : '?',
              style: TextStyle(
                color: rolColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                usuario.nombre,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: rolColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: rolColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(rolIcon, size: 12, color: rolColor),
                  const SizedBox(width: 4),
                  Text(
                    usuario.rol == 'guardia' ? 'Guardia' : 'Residente',
                    style: TextStyle(
                      fontSize: 11,
                      color: rolColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.email, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  usuario.email,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
            if (usuario.telefono != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.phone, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    usuario.telefono!,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
            if (usuario.numeroUnidad != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.door_front_door_outlined,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Unidad: ${usuario.numeroUnidad}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showUsuarioForm(context, adminState, usuario);
            } else if (value == 'delete') {
              _confirmDelete(context, adminState, usuario);
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
        onTap: () => _showUsuarioDetail(context, usuario),
      ),
    );
  }

  void _showUsuarioForm(
    BuildContext context,
    AdminState adminState,
    Usuario? existente,
  ) {
    final nombreCtrl = TextEditingController(text: existente?.nombre ?? '');
    final emailCtrl = TextEditingController(text: existente?.email ?? '');
    final passwordCtrl = TextEditingController();
    final telefonoCtrl = TextEditingController(text: existente?.telefono ?? '');
    final formKey = GlobalKey<FormState>();

    String rolSeleccionado = existente?.rol ?? 'residente';
    int? unidadSeleccionadaId;

    if (existente != null) {
      final match = adminState.unidades.where(
        (u) => u.numeroUnidad == existente.numeroUnidad,
      );
      if (match.isNotEmpty) {
        unidadSeleccionadaId = match.first.id;
      }
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                existente != null ? 'Editar Usuario' : 'Crear Nuevo Usuario',
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nombreCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator:
                            (v) =>
                                v == null || v.trim().isEmpty
                                    ? 'Requerido'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: emailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Requerido';
                          if (!v.contains('@')) return 'Email inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordCtrl,
                        decoration: InputDecoration(
                          labelText:
                              existente != null
                                  ? 'Nueva contraseña (dejar vacío para mantener)'
                                  : 'Contraseña',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (v) {
                          if (existente == null &&
                              (v == null || v.trim().isEmpty))
                            return 'Requerido';
                          if (v != null && v.isNotEmpty && v.length < 6)
                            return 'Mínimo 6 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: telefonoCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono (opcional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: rolSeleccionado,
                        decoration: const InputDecoration(
                          labelText: 'Rol',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.badge),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'residente',
                            child: Text('Residente'),
                          ),
                          DropdownMenuItem(
                            value: 'guardia',
                            child: Text('Guardia'),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null)
                            setDialogState(() => rolSeleccionado = v);
                        },
                      ),
                      if (rolSeleccionado == 'residente') ...[
                        const SizedBox(height: 16),
                        if (adminState.unidades.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.orange.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.warning_amber,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'No hay unidades disponibles. Crea una unidad primero.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.orange[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          DropdownButtonFormField<int>(
                            value: unidadSeleccionadaId,
                            decoration: const InputDecoration(
                              labelText: 'Unidad',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.door_front_door_outlined),
                            ),
                            hint: const Text('Seleccionar unidad'),
                            items:
                                adminState.unidades
                                    .map(
                                      (u) => DropdownMenuItem(
                                        value: u.id,
                                        child: Text(u.numeroUnidad),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                (v) => setDialogState(
                                  () => unidadSeleccionadaId = v,
                                ),
                          ),
                      ],
                    ],
                  ),
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

                    final data = <String, dynamic>{
                      'nombre': nombreCtrl.text.trim(),
                      'email': emailCtrl.text.trim(),
                      'telefono':
                          telefonoCtrl.text.trim().isEmpty
                              ? null
                              : telefonoCtrl.text.trim(),
                      'rol': rolSeleccionado,
                    };

                    if (existente == null || passwordCtrl.text.isNotEmpty) {
                      data['password'] = passwordCtrl.text.trim();
                    }

                    if (rolSeleccionado == 'residente') {
                      if (adminState.unidades.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No hay unidades disponibles'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (unidadSeleccionadaId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Selecciona una unidad'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      data['unidadId'] = unidadSeleccionadaId;
                      data['nuevaUnidadNumero'] = null;
                    }

                    bool exito;
                    if (existente != null) {
                      exito = await adminState.actualizarUsuario(
                        existente.id,
                        data,
                      );
                    } else {
                      exito = await adminState.crearUsuario(data);
                    }

                    if (!mounted) return;
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          exito
                              ? (existente != null
                                  ? 'Usuario actualizado'
                                  : 'Usuario creado')
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
                    existente != null ? 'Guardar Cambios' : 'Crear Usuario',
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
    Usuario usuario,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Eliminar Usuario'),
          content: Text(
            '¿Estás seguro de eliminar a "${usuario.nombre}"?\n\nSe eliminarán todas sus relaciones y datos asociados.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final exito = await adminState.eliminarUsuario(usuario.id);
                if (!mounted) return;
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      exito ? 'Usuario eliminado' : 'Error al eliminar usuario',
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

  void _showUsuarioDetail(BuildContext context, Usuario usuario) {
    final Color rolColor =
        usuario.rol == 'guardia' ? Colors.orange : Colors.teal;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(usuario.nombre),
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
                      color: rolColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        usuario.nombre.isNotEmpty
                            ? usuario.nombre[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: rolColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _detailRow(Icons.email, 'Email', usuario.email),
                const SizedBox(height: 8),
                _detailRow(
                  Icons.phone,
                  'Teléfono',
                  usuario.telefono ?? 'Sin registro',
                ),
                const SizedBox(height: 8),
                _detailRow(Icons.badge, 'Rol', _rolLabel(usuario.rol)),
                const SizedBox(height: 8),
                _detailRow(
                  Icons.door_front_door_outlined,
                  'Unidad',
                  usuario.numeroUnidad ?? 'Sin asignar',
                ),
                if (usuario.fechaCreacion != null) ...[
                  const SizedBox(height: 8),
                  _detailRow(
                    Icons.calendar_today,
                    'Registrado',
                    usuario.fechaCreacion!,
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  String _rolLabel(String rol) {
    switch (rol) {
      case 'guardia':
        return 'Guardia';
      case 'residente':
        return 'Residente';
      case 'administrador':
        return 'Administrador';
      default:
        return rol;
    }
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  void _showNoCondominiumDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Condominio no seleccionado'),
          content: const Text(
            'Selecciona un condominio desde la pantalla de inicio o condominios.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
