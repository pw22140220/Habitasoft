import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/anuncio_model.dart';
import 'admin_state.dart';

class AdminAnunciosScreen extends StatefulWidget {
  const AdminAnunciosScreen({super.key});

  @override
  State<AdminAnunciosScreen> createState() => _AdminAnunciosScreenState();
}

class _AdminAnunciosScreenState extends State<AdminAnunciosScreen> {
  String _filtro = 'todos';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adminState = context.read<AdminState>();
      if (adminState.hasSelectedCondominium) {
        adminState.cargarAnuncios();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminState = context.watch<AdminState>();
    List<Anuncio> anuncios = List.from(adminState.anuncios);

    if (_filtro == 'activos') {
      anuncios = anuncios.where((a) => a.activo).toList();
    } else if (_filtro == 'destacados') {
      anuncios = anuncios.where((a) => a.destacado).toList();
    }
    anuncios.sort((a, b) {
      if (a.destacado != b.destacado) return b.destacado ? 1 : -1;
      return 0;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anuncios'),
        backgroundColor: Colors.green[700],
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!adminState.hasSelectedCondominium) {
            _showNoCondominiumDialog();
          } else {
            _showAnuncioForm(context, adminState, null);
          }
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          if (adminState.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child:
                  anuncios.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                        onRefresh: () async => adminState.cargarAnuncios(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: anuncios.length,
                          itemBuilder:
                              (context, index) => _buildAnuncioCard(
                                anuncios[index],
                                adminState,
                              ),
                        ),
                      ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _filterChip('Todos', 'todos'),
          const SizedBox(width: 8),
          _filterChip('Activos', 'activos'),
          const SizedBox(width: 8),
          _filterChip('Destacados', 'destacados'),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final selected = _filtro == value;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: selected ? Colors.white : Colors.grey[700],
        ),
      ),
      selected: selected,
      selectedColor: Colors.green[700],
      onSelected: (_) => setState(() => _filtro = value),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.campaign_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay anuncios',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea el primer anuncio',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildAnuncioCard(Anuncio anuncio, AdminState adminState) {
    final bool expirado =
        anuncio.fechaExpiracion != null && anuncio.fechaExpiracion!.isNotEmpty;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: anuncio.destacado ? Colors.amber.withOpacity(0.08) : null,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      anuncio.destacado ? Icons.star : Icons.campaign,
                      color: anuncio.destacado ? Colors.amber : Colors.teal,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                anuncio.titulo,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (anuncio.destacado)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  '★',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                            if (!anuncio.activo) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Inactivo',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                            PopupMenuButton<String>(
                              onSelected: (v) {
                                if (v == 'edit')
                                  _showAnuncioForm(
                                    context,
                                    adminState,
                                    anuncio,
                                  );
                                else if (v == 'delete')
                                  _confirmDelete(context, adminState, anuncio);
                              },
                              itemBuilder:
                                  (_) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Editar'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text(
                                        'Eliminar',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          anuncio.contenido,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            if (anuncio.creadorNombre != null) ...[
                              Icon(
                                Icons.person,
                                size: 11,
                                color: Colors.grey[400],
                              ),
                              Text(
                                anuncio.creadorNombre!,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                            if (anuncio.fechaCreacion != null) ...[
                              Icon(
                                Icons.calendar_today,
                                size: 11,
                                color: Colors.grey[400],
                              ),
                              Text(
                                _formatFecha(anuncio.fechaCreacion!),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                            if (expirado) ...[
                              Icon(
                                Icons.access_time,
                                size: 11,
                                color: Colors.grey[400],
                              ),
                              Text(
                                'Exp: ${anuncio.fechaExpiracion}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (anuncio.destacado)
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showAnuncioForm(
    BuildContext context,
    AdminState adminState,
    Anuncio? existente,
  ) {
    final tituloCtrl = TextEditingController(text: existente?.titulo ?? '');
    final contenidoCtrl = TextEditingController(
      text: existente?.contenido ?? '',
    );
    final formKey = GlobalKey<FormState>();
    bool destacado = existente?.destacado ?? false;
    bool activo = existente?.activo ?? true;
    String? fechaExp = existente?.fechaExpiracion;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                existente != null ? 'Editar Anuncio' : 'Nuevo Anuncio',
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: tituloCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator:
                            (v) =>
                                v == null || v.trim().isEmpty
                                    ? 'Requerido'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: contenidoCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Contenido',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 5,
                        validator:
                            (v) =>
                                v == null || v.trim().isEmpty
                                    ? 'Requerido'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: SwitchListTile(
                              title: const Text(
                                'Destacado',
                                style: TextStyle(fontSize: 14),
                              ),
                              value: destacado,
                              activeColor: Colors.amber,
                              onChanged:
                                  (v) => setDialogState(() => destacado = v),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          Expanded(
                            child: SwitchListTile(
                              title: const Text(
                                'Activo',
                                style: TextStyle(fontSize: 14),
                              ),
                              value: activo,
                              activeColor: Colors.green,
                              onChanged:
                                  (v) => setDialogState(() => activo = v),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate:
                                fechaExp != null
                                    ? DateTime.parse(fechaExp!)
                                    : DateTime.now().add(
                                      const Duration(days: 30),
                                    ),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365 * 5),
                            ),
                          );
                          if (date != null) {
                            setDialogState(() {
                              fechaExp =
                                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Fecha de expiración (opcional)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                          child: Text(
                            fechaExp ?? 'Sin fecha de expiración',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  fechaExp != null
                                      ? Colors.black87
                                      : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      if (fechaExp != null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed:
                                () => setDialogState(() => fechaExp = null),
                            child: const Text(
                              'Quitar fecha',
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                          ),
                        ),
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
                      'titulo': tituloCtrl.text.trim(),
                      'contenido': contenidoCtrl.text.trim(),
                      'destacado': destacado,
                      'activo': activo,
                      'fechaExpiracion': fechaExp,
                      'imagenUrl': null,
                    };
                    bool exito;
                    if (existente != null) {
                      exito = await adminState.actualizarAnuncio(
                        existente.id,
                        data,
                      );
                    } else {
                      exito = await adminState.crearAnuncio(data);
                    }
                    if (!mounted) return;
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          exito
                              ? (existente != null
                                  ? 'Anuncio actualizado'
                                  : 'Anuncio creado')
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
                    existente != null ? 'Guardar' : 'Crear',
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
    Anuncio anuncio,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Eliminar Anuncio'),
          content: Text('¿Eliminar el anuncio "${anuncio.titulo}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final exito = await adminState.eliminarAnuncio(anuncio.id);
                if (!mounted) return;
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      exito ? 'Anuncio eliminado' : 'Error al eliminar anuncio',
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

  String _formatFecha(String? fecha) {
    if (fecha == null || fecha.length < 10) return '';
    final parts = fecha.substring(0, 10).split('-');
    if (parts.length != 3) return fecha.substring(0, 10);
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  void _showNoCondominiumDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Condominio no seleccionado'),
            content: const Text('Selecciona un condominio primero.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cerrar'),
              ),
            ],
          ),
    );
  }
}
