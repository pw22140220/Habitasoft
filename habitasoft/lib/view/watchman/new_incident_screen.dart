import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/incidente_model.dart';
import '../../providers/incidente_provider.dart';

class NewIncidentScreen extends StatefulWidget {
  final String userName;
  final String? token;

  const NewIncidentScreen({super.key, required this.userName, this.token});

  @override
  State<NewIncidentScreen> createState() => _NewIncidentScreenState();
}

class _NewIncidentScreenState extends State<NewIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _titleController = TextEditingController();

  String _selectedType = 'Seguridad';
  String _selectedPriority = 'MEDIA';

  final List<String> _types = ['Seguridad', 'Mantenimiento', 'General'];
  final List<String> _priorities = ['ALTA', 'MEDIA', 'BAJA'];

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<IncidenteProvider>();
    provider.setToken(widget.token);

    final incidente = Incidente(
      id: 0,
      reportadoPorId: 0,
      titulo: _titleController.text.trim(),
      descripcion: _descriptionController.text.trim(),
      tipo: _selectedType,
      ubicacion: _locationController.text.trim(),
      prioridad: _selectedPriority,
      estado: 'nuevo',
    );

    final success = await provider.crear(incidente);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incidente creado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Error al crear incidente'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _priorityLabel(String p) {
    switch (p) {
      case 'ALTA':
        return 'Alta';
      case 'MEDIA':
        return 'Media';
      case 'BAJA':
        return 'Baja';
      default:
        return p;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Incidente'),
        backgroundColor: const Color(0xFF15806C),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Título',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Ej: Intento de ingreso no autorizado',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                validator:
                    (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'El título es obligatorio'
                            : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Tipo de Incidente',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                items:
                    _types
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ubicación',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Ej: Portón principal, Estacionamiento B, ...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                validator:
                    (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'La ubicación es obligatoria'
                            : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Prioridad',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                items:
                    _priorities.map((p) {
                      Color color;
                      switch (p) {
                        case 'ALTA':
                          color = Colors.red;
                        case 'MEDIA':
                          color = Colors.orange;
                        case 'BAJA':
                          color = Colors.blue;
                        default:
                          color = Colors.grey;
                      }
                      return DropdownMenuItem(
                        value: p,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(_priorityLabel(p)),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (v) => setState(() => _selectedPriority = v!),
              ),
              const SizedBox(height: 16),
              const Text(
                'Descripción',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Describe el incidente en detalle...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                validator:
                    (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'La descripción es obligatoria'
                            : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF15806C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Guardar Incidente',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
