import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/usuario_model.dart';
import '../../services/pago_service.dart';
import '../../services/usuario_service.dart';
import 'admin_state.dart';

class AdminCrearRecordatorioScreen extends StatefulWidget {
  const AdminCrearRecordatorioScreen({super.key});

  @override
  State<AdminCrearRecordatorioScreen> createState() =>
      _AdminCrearRecordatorioScreenState();
}

class _AdminCrearRecordatorioScreenState
    extends State<AdminCrearRecordatorioScreen> {
  final _formKey = GlobalKey<FormState>();
  Usuario? _residenteSeleccionado;
  final _montoController = TextEditingController();
  final _periodoController = TextEditingController();
  DateTime? _fechaVencimiento;
  List<Usuario> _residentes = [];
  bool _isLoading = false;
  bool _isSaving = false;
  bool _enviarNotificacion = true;

  @override
  void initState() {
    super.initState();
    _cargarResidentes();
  }

  @override
  void dispose() {
    _montoController.dispose();
    _periodoController.dispose();
    super.dispose();
  }

  PagoService get _pagoService {
    final token = Provider.of<AdminState>(context, listen: false).token;
    return PagoService(token: token);
  }

  Future<void> _cargarResidentes() async {
    final adminState = Provider.of<AdminState>(context, listen: false);
    if (adminState.selectedCondominio == null) return;

    setState(() => _isLoading = true);
    try {
      final token = adminState.token;
      final service = UsuarioService(token: token);
      final usuarios = await service.listar(adminState.selectedCondominio!.id);
      setState(
        () =>
            _residentes = usuarios.where((u) => u.rol == 'residente').toList(),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar residentes')),
        );
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _fechaVencimiento = picked);
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_residenteSeleccionado == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecciona un residente')));
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _pagoService.crearRecordatorio(
        _residenteSeleccionado!.id,
        double.parse(_montoController.text),
        _periodoController.text.isNotEmpty ? _periodoController.text : null,
        _fechaVencimiento != null
            ? _fechaVencimiento!.toIso8601String().split('T')[0]
            : null,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recordatorio creado y notificación enviada'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear recordatorio')),
        );
      }
    }
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Recordatorio de Pago'),
        backgroundColor: Colors.orange[700],
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Residente
              Text(
                'Residente',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<Usuario>(
                    value: _residenteSeleccionado,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    hint: const Text('Seleccionar residente'),
                    items:
                        _residentes
                            .map(
                              (r) => DropdownMenuItem(
                                value: r,
                                child: Text(
                                  '${r.nombre} (${r.numeroUnidad ?? "Sin unidad"})',
                                ),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (v) => setState(() => _residenteSeleccionado = v),
                  ),
              const SizedBox(height: 16),

              // Monto
              Text(
                'Monto',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _montoController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Ingresa un monto';
                  }
                  if (double.tryParse(v) == null || double.parse(v) <= 0) {
                    return 'Monto inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Periodo
              Text(
                'Período (ej: Mayo 2025)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _periodoController,
                decoration: InputDecoration(
                  hintText: 'Ej: Mayo 2025',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Fecha de vencimiento
              Text(
                'Fecha de vencimiento (opcional)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _seleccionarFecha,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _fechaVencimiento != null
                            ? _fechaVencimiento!.toIso8601String().split('T')[0]
                            : 'Seleccionar fecha',
                        style: TextStyle(
                          color:
                              _fechaVencimiento != null
                                  ? Colors.black
                                  : Colors.grey[500],
                        ),
                      ),
                      const Icon(Icons.calendar_today, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Enviar notificación
              CheckboxListTile(
                title: const Text('Enviar notificación al residente'),
                value: _enviarNotificacion,
                onChanged:
                    (v) => setState(() => _enviarNotificacion = v ?? true),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),

              // Botón guardar
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _guardar,
                icon:
                    _isSaving
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Icon(Icons.send),
                label: Text(_isSaving ? 'Guardando...' : 'Crear recordatorio'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
