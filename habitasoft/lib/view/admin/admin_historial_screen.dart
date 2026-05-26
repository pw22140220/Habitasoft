import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/condominio_model.dart';
import '../../models/historial_acceso_model.dart';
import '../../services/historial_acceso_service.dart';
import 'admin_state.dart';

class AdminHistorialScreen extends StatefulWidget {
  const AdminHistorialScreen({super.key});

  @override
  State<AdminHistorialScreen> createState() => _AdminHistorialScreenState();
}

class _AdminHistorialScreenState extends State<AdminHistorialScreen> {
  final HistorialAccesoService _historialService = HistorialAccesoService();
  List<HistorialAcceso> _accesos = [];
  Map<String, dynamic>? _stats;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adminState = Provider.of<AdminState>(context);
    if (adminState.token != null) {
      _initService(adminState);
    }
  }

  void _initService(AdminState adminState) {
    final token = adminState.token;
    if (token == null) return;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatos();
    });
  }

  int? _getCondominioId() {
    final adminState = Provider.of<AdminState>(context, listen: false);
    final token = adminState.token;
    return adminState.selectedCondominio?.id;
  }

  Future<void> _cargarDatos() async {
    final adminState = Provider.of<AdminState>(context, listen: false);
    final condominioId = adminState.selectedCondominio?.id;
    if (condominioId == null) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);
    final service = HistorialAccesoService(token: adminState.token);
    try {
      final results = await Future.wait([
        service.listarPorAdmin(condominioId),
        service.obtenerEstadisticasAdmin(condominioId),
      ]);
      setState(() {
        _accesos = results[0] as List<HistorialAcceso>;
        _stats = results[1] as Map<String, dynamic>;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar historial: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatFecha(String? fechaStr) {
    if (fechaStr == null) return '';
    try {
      final dt = DateTime.parse(fechaStr);
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return fechaStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminState = Provider.of<AdminState>(context);
    final condominio = adminState.selectedCondominio;

    if (condominio == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Historial de Accesos'),
          backgroundColor: Colors.green[700],
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.apartment, size: 80, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                'Selecciona un condominio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Text(
                'Para ver el historial de accesos',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Historial - ${condominio.nombre}'),
        backgroundColor: Colors.green[700],
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.swap_horiz, color: Colors.white),
            tooltip: 'Cambiar condominio',
            onSelected: (value) {
              final c = adminState.getCondominiumById(value);
              if (c != null) {
                adminState.selectCondominium(c);
                _cargarDatos();
              }
            },
            itemBuilder:
                (context) =>
                    adminState.condominios.map((c) {
                      return PopupMenuItem(
                        value: c.id,
                        child: Row(
                          children: [
                            if (c.id == condominio.id)
                              const Icon(
                                Icons.check,
                                size: 18,
                                color: Colors.green,
                              ),
                            const SizedBox(width: 8),
                            Text(c.nombre),
                          ],
                        ),
                      );
                    }).toList(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _cargarDatos,
        child: CustomScrollView(
          slivers: [
            if (_stats != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildStatCard(
                        'Hoy',
                        _stats!['accesosHoy'].toString(),
                        Colors.blue,
                      ),
                      _buildStatCard(
                        'Semana',
                        _stats!['accesosSemana'].toString(),
                        Colors.orange,
                      ),
                      _buildStatCard(
                        'Mes',
                        _stats!['accesosMes'].toString(),
                        Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_accesos.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No hay accesos registrados en este condominio',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final acceso = _accesos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.arrow_forward,
                        color: Colors.green,
                      ),
                      title: Text(acceso.nombreVisitante),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (acceso.residenteNombre != null)
                            Text('Residente: ${acceso.residenteNombre}'),
                          if (acceso.unidadNumero != null)
                            Text('Unidad: ${acceso.unidadNumero}'),
                          if (acceso.guardiaNombre != null)
                            Text('Guardia: ${acceso.guardiaNombre}'),
                        ],
                      ),
                      trailing: Text(
                        _formatFecha(acceso.fechaAcceso),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }, childCount: _accesos.length),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String titulo, String valor, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              titulo,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              valor,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
