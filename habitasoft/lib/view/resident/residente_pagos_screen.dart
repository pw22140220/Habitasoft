import 'package:flutter/material.dart';
import '../../models/pago_model.dart';
import '../../services/pago_service.dart';

class ResidentePagosScreen extends StatefulWidget {
  final String userName;
  final String? token;

  const ResidentePagosScreen({super.key, required this.userName, this.token});

  @override
  State<ResidentePagosScreen> createState() => _ResidentePagosScreenState();
}

class _ResidentePagosScreenState extends State<ResidentePagosScreen> {
  List<Pago> _pagos = [];
  bool _isLoading = false;
  String? _error;

  PagoService get _service => PagoService(token: widget.token);

  @override
  void initState() {
    super.initState();
    _cargarPagos();
  }

  Future<void> _cargarPagos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final pagos = await _service.listarMisPagos();
      setState(() => _pagos = pagos);
    } catch (e) {
      setState(() => _error = 'Error al cargar pagos');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _marcarComoPagado(Pago pago) async {
    final metodo = await showDialog<String>(
      context: context,
      builder:
          (ctx) => SimpleDialog(
            title: const Text('Seleccionar método de pago'),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, 'transferencia'),
                child: const Text('Transferencia'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, 'tarjeta'),
                child: const Text('Tarjeta'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, 'efectivo'),
                child: const Text('Efectivo'),
              ),
            ],
          ),
    );
    if (metodo == null) return;

    try {
      await _service.marcarComoPagado(pago.id, metodoPago: metodo);
      _cargarPagos();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pago registrado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error al procesar pago')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalAdeudado = _pagos
        .where((p) => p.estado == 'pendiente' || p.estado == 'vencido')
        .fold(0.0, (sum, p) => sum + p.monto);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTotalAdeudado(totalAdeudado),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                      ? Center(child: Text(_error!))
                      : _pagos.isEmpty
                      ? const Center(child: Text('No tienes pagos registrados'))
                      : RefreshIndicator(
                        onRefresh: _cargarPagos,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          itemCount: _pagos.length,
                          itemBuilder: (ctx, i) => _buildPagoCard(_pagos[i]),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[700]!, Colors.orange[500]!],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mis Pagos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.userName,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAdeudado(double total) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange[400]!, Colors.orange[400]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total adeudado',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
                      pago.periodo ?? 'Pago #${pago.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                    ),
                    if (pago.fechaVencimiento != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          pago.estado == 'vencido'
                              ? 'Vencido: ${pago.fechaVencimiento}'
                              : 'Vence: ${pago.fechaVencimiento}',
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                pago.estado == 'vencido'
                                    ? Colors.red[400]
                                    : Colors.grey,
                          ),
                        ),
                      ),
                    if (pago.fechaPago != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Pagado: ${pago.fechaPago}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
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
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: estadoColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      pago.estadoTexto,
                      style: TextStyle(
                        fontSize: 12,
                        color: estadoColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (pago.estado != 'pagado') ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _marcarComoPagado(pago),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Ver detalles',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0B64D8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => _marcarComoPagado(pago),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Pagar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
