import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/pago_model.dart';
import '../../services/pago_service.dart';
import '../admin/admin_state.dart';
import 'admin_crear_recordatorio_screen.dart';

class AdminPagosScreen extends StatefulWidget {
  const AdminPagosScreen({super.key});

  @override
  State<AdminPagosScreen> createState() => _AdminPagosScreenState();
}

class _AdminPagosScreenState extends State<AdminPagosScreen> {
  List<Pago> _pagos = [];
  bool _isLoading = false;
  String? _error;
  String _filtroEstado = '';
  String _searchQuery = '';

  PagoService get _service {
    final token = Provider.of<AdminState>(context, listen: false).token;
    return PagoService(token: token);
  }

  int? _lastCondominioId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adminState = Provider.of<AdminState>(context, listen: false);
      _lastCondominioId = adminState.selectedCondominio?.id;
      _cargarPagos();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adminState = Provider.of<AdminState>(context);
    final currentId = adminState.selectedCondominio?.id;
    if (currentId != _lastCondominioId) {
      _lastCondominioId = currentId;
      _cargarPagos();
    }
  }

  Future<void> _cargarPagos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final adminState = Provider.of<AdminState>(context, listen: false);
      final pagos = await _service.listarPagosAdmin(
        estado: _filtroEstado.isNotEmpty ? _filtroEstado : null,
        condominioId: adminState.selectedCondominio?.id,
      );
      setState(() => _pagos = pagos);
    } catch (e) {
      setState(() => _error = 'Error al cargar pagos');
    }
    setState(() => _isLoading = false);
  }

  List<Pago> get _pagosFiltrados {
    if (_searchQuery.isEmpty) return _pagos;
    final q = _searchQuery.toLowerCase();
    return _pagos
        .where(
          (p) =>
              p.residenteNombre.toLowerCase().contains(q) ||
              (p.periodo?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }

  void _navegarACrear() async {
    final creado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AdminCrearRecordatorioScreen()),
    );
    if (creado == true) _cargarPagos();
  }

  Future<void> _registrarPagoManual(Pago pago) async {
    final metodo = await showDialog<String>(
      context: context,
      builder:
          (ctx) => SimpleDialog(
            title: const Text('Registrar pago manual'),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, 'efectivo'),
                child: const Text('Efectivo'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, 'transferencia'),
                child: const Text('Transferencia'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, 'tarjeta'),
                child: const Text('Tarjeta'),
              ),
            ],
          ),
    );
    if (metodo == null) return;

    try {
      await _service.registrarPagoManual(pago.id, metodoPago: metodo);
      _cargarPagos();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar pago')),
        );
      }
    }
  }

  Future<void> _eliminarPago(Pago pago) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Eliminar pago'),
            content: Text(
              'Eliminar el pago de ${pago.residenteNombre} por \$${pago.monto.toStringAsFixed(2)}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
    if (confirm != true) return;

    try {
      await _service.eliminar(pago.id);
      _cargarPagos();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error al eliminar pago')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalRecaudado = _pagos
        .where((p) => p.estado == 'pagado')
        .fold(0.0, (sum, p) => sum + p.monto);
    final pendientes = _pagos.where((p) => p.estado == 'pendiente').length;
    final morosos = _pagos.where((p) => p.estado == 'vencido').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordatorios de Pago'),
        backgroundColor: Colors.orange[700],
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_pagos',
        onPressed: _navegarACrear,
        backgroundColor: Colors.orange[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildResumenCards(totalRecaudado, pendientes, morosos),
          _buildFiltros(),
          _buildSearchBar(),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Center(child: Text(_error!))
                    : _pagosFiltrados.isEmpty
                    ? const Center(child: Text('No hay pagos registrados'))
                    : RefreshIndicator(
                      onRefresh: _cargarPagos,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: _pagosFiltrados.length,
                        itemBuilder:
                            (ctx, i) => _buildPagoCard(_pagosFiltrados[i]),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumenCards(double total, int pendientes, int morosos) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.orange[50],
      child: Row(
        children: [
          _resumenCard(
            Icons.account_balance_wallet,
            'Total Recaudado',
            '\$${total.toStringAsFixed(2)}',
            Colors.green,
          ),
          _resumenCard(
            Icons.hourglass_empty,
            'Pendientes',
            '$pendientes',
            Colors.orange,
          ),
          _resumenCard(Icons.warning_amber, 'Morosos', '$morosos', Colors.red),
        ],
      ),
    );
  }

  Widget _resumenCard(IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFiltros() {
    final filtros = ['', 'pendiente', 'pagado', 'vencido'];
    final labels = ['Todos', 'Pendientes', 'Pagados', 'Vencidos'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: List.generate(filtros.length, (i) {
          final selected = _filtroEstado == filtros[i];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(labels[i]),
              selected: selected,
              onSelected: (_) {
                setState(() => _filtroEstado = filtros[i]);
                _cargarPagos();
              },
              selectedColor: Colors.orange[100],
              checkmarkColor: Colors.orange[700],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar por residente o período...',
          prefixIcon: const Icon(Icons.search, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          isDense: true,
        ),
        onChanged: (v) => setState(() => _searchQuery = v),
      ),
    );
  }

  Widget _buildPagoCard(Pago pago) {
    final Color estadoColor;
    switch (pago.estado) {
      case 'pagado':
        estadoColor = Colors.green;
        break;
      case 'vencido':
        estadoColor = Colors.red;
        break;
      default:
        estadoColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pago.residenteNombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      if (pago.periodo != null)
                        Text(
                          pago.periodo!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${pago.monto.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: estadoColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        pago.estadoTexto,
                        style: TextStyle(
                          color: estadoColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (pago.fechaVencimiento != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Vence: ${pago.fechaVencimiento}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),
            if (pago.fechaPago != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  'Pagado: ${pago.fechaPago} | ${pago.metodoPagoTexto}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (pago.estado != 'pagado')
                  TextButton.icon(
                    onPressed: () => _registrarPagoManual(pago),
                    icon: const Icon(Icons.payment, size: 18),
                    label: const Text('Registrar pago'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green[700],
                    ),
                  ),
                IconButton(
                  onPressed: () => _eliminarPago(pago),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
