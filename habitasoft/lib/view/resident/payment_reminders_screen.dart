import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'profile_screen.dart';
import '../../models/pago_model.dart';
import '../../services/pago_service.dart';

class PaymentRemindersScreen extends StatefulWidget {
  final String userName;
  final String? token;

  const PaymentRemindersScreen({super.key, required this.userName, this.token});

  @override
  State<PaymentRemindersScreen> createState() => _PaymentRemindersScreenState();
}

class _PaymentRemindersScreenState extends State<PaymentRemindersScreen> {
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
    final pendientes =
        _pagos
            .where((p) => p.estado == 'pendiente' || p.estado == 'vencido')
            .toList();
    final realizados = _pagos.where((p) => p.estado == 'pagado').toList();
    final totalAdeudado = pendientes.fold(0.0, (sum, p) => sum + p.monto);
    final totalRealizado = realizados.fold(0.0, (sum, p) => sum + p.monto);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            _PaymentHeader(onBack: () => Navigator.pop(context)),
            _SummaryCards(
              totalAdeudado: totalAdeudado,
              pendientesCount: pendientes.length,
              realizadosCount: realizados.length,
              totalRealizado: totalRealizado,
            ),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                      ? Center(child: Text(_error!))
                      : _pagos.isEmpty
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No tienes pagos pendientes',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      : RefreshIndicator(
                        onRefresh: _cargarPagos,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          children: [
                            if (pendientes.isNotEmpty) ...[
                              const Padding(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                child: Text(
                                  'Pendientes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ),
                              ...pendientes.map(
                                (p) => _PaymentCard(
                                  pago: p,
                                  onPagar: () => _marcarComoPagado(p),
                                ),
                              ),
                            ],
                            if (realizados.isNotEmpty) ...[
                              const Padding(
                                padding: EdgeInsets.only(top: 16, bottom: 8),
                                child: Text(
                                  'Realizados',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ),
                              ...realizados.map(
                                (p) => _PaymentCard(pago: p, onPagar: null),
                              ),
                            ],
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _PaymentBottomNavBar(
        userName: widget.userName,
        token: widget.token,
      ),
    );
  }
}

class _PaymentHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _PaymentHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
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
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          const SizedBox(width: 4),
          const Text(
            'Recordatorios de Pago',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  final double totalAdeudado;
  final int pendientesCount;
  final int realizadosCount;
  final double totalRealizado;

  const _SummaryCards({
    required this.totalAdeudado,
    required this.pendientesCount,
    required this.realizadosCount,
    required this.totalRealizado,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              icon: Icons.pending_actions,
              label: 'Pendientes',
              value: '\$${totalAdeudado.toStringAsFixed(2)}',
              subtitle: '$pendientesCount pendiente(s)',
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryCard(
              icon: Icons.check_circle_outline,
              label: 'Realizados',
              value: '\$${totalRealizado.toStringAsFixed(2)}',
              subtitle: '$realizadosCount pagado(s)',
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final Pago pago;
  final VoidCallback? onPagar;

  const _PaymentCard({required this.pago, this.onPagar});

  @override
  Widget build(BuildContext context) {
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
                    const SizedBox(height: 4),
                    Text(
                      pago.estado == 'vencido'
                          ? 'Vencido: ${pago.fechaVencimiento ?? "—"}'
                          : 'Vence: ${pago.fechaVencimiento ?? "—"}',
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            pago.estado == 'vencido'
                                ? Colors.red[400]
                                : Colors.grey,
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
          if (pago.estado != 'pagado' && onPagar != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onPagar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Pagar ahora',
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

class _PaymentBottomNavBar extends StatelessWidget {
  final String userName;
  final String? token;

  const _PaymentBottomNavBar({required this.userName, this.token});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => DashboardScreen(userName: userName, token: token),
                ),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => ProfileScreen(userName: userName, token: token),
                ),
              );
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0B64D8),
        unselectedItemColor: const Color(0xFF9E9E9E),
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24),
            activeIcon: Icon(Icons.home, size: 24),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined, size: 24),
            activeIcon: Icon(Icons.calendar_today, size: 24),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none, size: 24),
            activeIcon: Icon(Icons.notifications, size: 24),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 24),
            activeIcon: Icon(Icons.person, size: 24),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
