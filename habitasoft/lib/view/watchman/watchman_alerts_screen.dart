import 'package:flutter/material.dart';
import '../../models/alerta_model.dart';
import '../../services/alerta_service.dart';
import '../../services/auth_service.dart';
import '../../services/biometric_preferences_service.dart';

class WatchmanAlertsScreen extends StatefulWidget {
  final String? token;

  const WatchmanAlertsScreen({super.key, this.token});

  @override
  State<WatchmanAlertsScreen> createState() => _WatchmanAlertsScreenState();
}

class _WatchmanAlertsScreenState extends State<WatchmanAlertsScreen> {
  List<Alerta> _alertas = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargarAlertas());
  }

  Future<String?> _getToken() async {
    if (widget.token != null) return widget.token;
    return BiometricPreferencesService.getToken();
  }

  Future<void> _cargarAlertas() async {
    final token = await _getToken();
    if (token == null || token.startsWith('mock-')) return;
    setState(() => _isLoading = true);
    final condominioId = await AuthService.obtenerCondominioIdGuardia(token);
    try {
      final service = AlertaService(token: token);
      final alertas = await service.listarActivasPorCondominioGuardia(
        condominioId,
      );
      if (mounted) setState(() => _alertas = alertas);
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  String _formatFecha(String? fecha) {
    if (fecha == null || fecha.length < 10) return '';
    final parts = fecha.substring(0, 10).split('-');
    if (parts.length != 3) return '';
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: const BoxDecoration(
                color: Color(0xFF15806C),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const Expanded(
                    child: Text(
                      'Alertas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_alertas.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${_alertas.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 28),
                ],
              ),
            ),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _alertas.isEmpty
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off_outlined,
                              size: 64,
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
                        onRefresh: _cargarAlertas,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                          itemCount: _alertas.length,
                          itemBuilder:
                              (ctx, i) => _AlertaCard(
                                alerta: _alertas[i],
                                fecha: _formatFecha(_alertas[i].fechaCreacion),
                              ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertaCard extends StatelessWidget {
  final Alerta alerta;
  final String fecha;

  const _AlertaCard({required this.alerta, required this.fecha});

  @override
  Widget build(BuildContext context) {
    final bool urgente =
        alerta.prioridad == 'alta' || alerta.prioridad == 'urgente';
    final Color accentColor =
        urgente ? const Color(0xFFD32F2F) : const Color(0xFF1976D2);
    final Color bgColor =
        urgente ? const Color(0xFFFFEBEE) : const Color(0xFFE3F2FD);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
            urgente
                ? Border.all(color: accentColor.withOpacity(0.3), width: 1)
                : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(
              urgente ? Icons.warning : Icons.info_outline,
              color: accentColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        alerta.titulo,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                    if (fecha.isNotEmpty)
                      Text(
                        fecha,
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  alerta.mensaje,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    alerta.prioridad,
                    style: TextStyle(
                      fontSize: 10,
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
