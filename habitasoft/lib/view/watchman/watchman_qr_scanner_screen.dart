import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../models/validar_qr_response.dart';
import '../../services/qr_service.dart';

class WatchmanQRScannerScreen extends StatefulWidget {
  final String userName;
  final String? token;

  const WatchmanQRScannerScreen({
    super.key,
    required this.userName,
    this.token,
  });

  @override
  State<WatchmanQRScannerScreen> createState() =>
      _WatchmanQRScannerScreenState();
}

class _WatchmanQRScannerScreenState extends State<WatchmanQRScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  final List<_ScanResult> _recentScans = [];
  bool _isProcessing = false;
  bool _flashOn = false;

  QrService get _service => QrService(token: widget.token);

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    _isProcessing = true;
    _validarQR(barcode!.rawValue!);
  }

  Future<void> _validarQR(String codigoQr) async {
    try {
      final response = await _service.validarQR(codigoQr);
      setState(() {
        _recentScans.insert(
          0,
          _ScanResult(
            nombreVisitante: response.nombreVisitante ?? '—',
            unidad: response.unidad ?? '—',
            residente: response.residenteNombre ?? '—',
            valido: response.valido,
            mensaje: response.mensaje,
            timestamp: DateTime.now(),
          ),
        );
      });
      _showResultDialog(response);
    } catch (e) {
      String errorMsg = e.toString().replaceFirst('Exception: ', '');
      setState(() {
        _recentScans.insert(
          0,
          _ScanResult(
            nombreVisitante: '—',
            unidad: '—',
            residente: '—',
            valido: false,
            mensaje: errorMsg,
            timestamp: DateTime.now(),
          ),
        );
      });
      _showErrorDialog(errorMsg);
    }
    _isProcessing = false;
  }

  void _showResultDialog(ValidarQrResponse response) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 64, color: Colors.green[600]),
                const SizedBox(height: 12),
                const Text(
                  'ACCESO PERMITIDO',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _detailRow('Visitante', response.nombreVisitante ?? '—'),
                      const SizedBox(height: 8),
                      _detailRow('Residente', response.residenteNombre ?? '—'),
                      const SizedBox(height: 8),
                      _detailRow('Unidad', response.unidad ?? '—'),
                      if (response.fechaValidez != null) ...[
                        const SizedBox(height: 8),
                        _detailRow('Válido hasta', response.fechaValidez!),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _scannerController.start();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF15806C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Aceptar', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(String errorMsg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cancel, size: 64, color: Colors.red[600]),
                const SizedBox(height: 12),
                const Text(
                  'ACCESO DENEGADO',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  errorMsg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _scannerController.start();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cerrar', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Escanear QR'),
        backgroundColor: const Color(0xFF15806C),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() => _flashOn = !_flashOn);
              _scannerController.toggleTorch();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scannerHeight =
              constraints.maxHeight < 600
                  ? constraints.maxHeight * 0.35
                  : 280.0;
          return Column(
            children: [
              Container(
                height: scannerHeight,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: _scannerController,
                      onDetect: _onDetect,
                    ),
                    _buildScanOverlay(scannerHeight),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Coloca el código QR dentro del marco',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'El escáner detectará automáticamente',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton.icon(
                  onPressed: () => _showManualEntryDialog(context),
                  icon: const Icon(Icons.keyboard),
                  label: const Text('Ingresar código manualmente'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 44),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.green[700]!),
                  ),
                ),
              ),
              if (_recentScans.isNotEmpty) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Escaneos Recientes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _recentScans.clear()),
                        child: const Text(
                          'Limpiar',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _recentScans.length,
                  itemBuilder: (context, index) {
                    final scan = _recentScans[index];
                    return _ScanCard(scan: scan);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScanOverlay(double parentHeight) {
    final overlaySize = parentHeight * 0.75;
    return Center(
      child: Container(
        width: overlaySize,
        height: overlaySize,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner,
              size: 60,
              color: Colors.white.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }

  void _showManualEntryDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Ingresar Código'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Código QR',
                hintText: 'Pega o escribe el código',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (controller.text.trim().isNotEmpty) {
                    _validarQR(controller.text.trim());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF15806C),
                ),
                child: const Text('Validar'),
              ),
            ],
          ),
    );
  }
}

class _ScanResult {
  final String nombreVisitante;
  final String unidad;
  final String residente;
  final bool valido;
  final String mensaje;
  final DateTime timestamp;

  _ScanResult({
    required this.nombreVisitante,
    required this.unidad,
    required this.residente,
    required this.valido,
    required this.mensaje,
    required this.timestamp,
  });
}

class _ScanCard extends StatelessWidget {
  final _ScanResult scan;

  const _ScanCard({required this.scan});

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final color = scan.valido ? Colors.green : Colors.red;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              scan.valido ? Icons.check_circle : Icons.cancel,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scan.nombreVisitante,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Unidad ${scan.unidad} | ${scan.residente}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  scan.valido ? 'Válido' : 'Inválido',
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTime(scan.timestamp),
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
