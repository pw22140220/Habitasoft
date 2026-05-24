import 'package:flutter/material.dart';
import '../../models/condominio_model.dart';
import '../../services/condominio_service.dart';

class AdminState extends ChangeNotifier {
  String? _token;
  Condominio? _selectedCondominio;
  List<Condominio> _condominios = [];
  bool _isLoading = false;
  String? _error;

  Condominio? get selectedCondominio => _selectedCondominio;
  List<Condominio> get condominios => _condominios;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasSelectedCondominium => _selectedCondominio != null;

  CondominioService get _service => CondominioService(token: _token);

  void setToken(String token) {
    _token = token;
  }

  Future<void> init() async {
    if (_token != null) {
      await cargarCondominios();
    }
  }

  Future<void> cargarCondominios() async {
    if (_token == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _condominios = await _service.listar();
    } catch (e) {
      _error = 'Error al cargar condominios';
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectCondominium(Condominio condominium) {
    _selectedCondominio = condominium;
    notifyListeners();
  }

  void clearSelectedCondominium() {
    _selectedCondominio = null;
    notifyListeners();
  }

  Future<bool> agregarCondominio(String nombre, String direccion) async {
    if (_token == null) return false;

    try {
      final nuevo = await _service.crear(nombre, direccion);
      _condominios.add(nuevo);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al crear condominio';
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarCondominio(int id) async {
    if (_token == null) return false;

    try {
      await _service.eliminar(id);
      _condominios.removeWhere((c) => c.id == id);
      if (_selectedCondominio?.id == id) {
        _selectedCondominio = null;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al eliminar condominio';
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizarCondominio(
    int id,
    String nombre,
    String direccion,
  ) async {
    if (_token == null) return false;

    try {
      final actualizado = await _service.actualizar(id, nombre, direccion);
      final index = _condominios.indexWhere((c) => c.id == id);
      if (index != -1) {
        _condominios[index] = actualizado;
      }
      if (_selectedCondominio?.id == id) {
        _selectedCondominio = actualizado;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al actualizar condominio';
      notifyListeners();
      return false;
    }
  }

  Condominio? getCondominiumById(int id) {
    try {
      return _condominios.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Condominio> searchCondominiums(String query) {
    if (query.isEmpty) return _condominios;
    final q = query.toLowerCase();
    return _condominios.where((c) {
      return c.nombre.toLowerCase().contains(q) ||
          c.direccion.toLowerCase().contains(q);
    }).toList();
  }
}
