import 'package:flutter/foundation.dart';
import '../models/incidente_model.dart';
import '../services/incidente_service.dart';

class IncidenteProvider extends ChangeNotifier {
  String? _token;
  IncidenteService? _service;

  List<Incidente> _incidentes = [];
  bool _isLoading = false;
  String? _error;

  List<Incidente> get incidentes => _incidentes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setToken(String? token) {
    _token = token;
    _service = IncidenteService(token: token);
  }

  Future<void> cargarMisIncidentes() async {
    if (_service == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _incidentes = await _service!.listarMisIncidentes();
    } catch (e) {
      _error = 'Error al cargar incidentes';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> cargarTodos({int? condominioId}) async {
    if (_service == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _incidentes = await _service!.listarTodos(condominioId: condominioId);
    } catch (e) {
      _error = 'Error al cargar incidentes';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> crear(Incidente incidente) async {
    if (_service == null) return false;
    try {
      await _service!.crear(incidente);
      await cargarMisIncidentes();
      return true;
    } catch (e) {
      _error = 'Error al crear incidente';
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizar(int id, Incidente incidente) async {
    if (_service == null) return false;
    try {
      await _service!.actualizar(id, incidente);
      await cargarMisIncidentes();
      return true;
    } catch (e) {
      _error = 'Error al actualizar incidente';
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizarEstado(int id, String estado) async {
    if (_service == null) return false;
    try {
      await _service!.actualizarEstado(id, estado);
      final index = _incidentes.indexWhere((i) => i.id == id);
      if (index != -1) {
        final old = _incidentes[index];
        _incidentes[index] = Incidente(
          id: old.id,
          reportadoPorId: old.reportadoPorId,
          condominioId: old.condominioId,
          nombreReportador: old.nombreReportador,
          titulo: old.titulo,
          descripcion: old.descripcion,
          tipo: old.tipo,
          ubicacion: old.ubicacion,
          prioridad: old.prioridad,
          estado: estado,
          fechaHoraIncidente: old.fechaHoraIncidente,
          fechaActualizacion: old.fechaActualizacion,
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = 'Error al actualizar estado';
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminar(int id) async {
    if (_service == null) return false;
    try {
      await _service!.eliminar(id);
      _incidentes.removeWhere((i) => i.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al eliminar incidente';
      notifyListeners();
      return false;
    }
  }
}
