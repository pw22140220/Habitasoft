import 'package:flutter/material.dart';
import '../../models/alerta_model.dart';
import '../../models/amenidad_model.dart';
import '../../models/condominio_model.dart';
import '../../services/alerta_service.dart';
import '../../services/amenidad_service.dart';
import '../../services/condominio_service.dart';

class AdminState extends ChangeNotifier {
  String? _token;
  Condominio? _selectedCondominio;
  List<Condominio> _condominios = [];
  List<Alerta> _alertas = [];
  List<Amenidad> _amenidades = [];
  bool _isLoading = false;
  String? _error;

  Condominio? get selectedCondominio => _selectedCondominio;
  List<Condominio> get condominios => _condominios;
  List<Alerta> get alertas => _alertas;
  List<Amenidad> get amenidades => _amenidades;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasSelectedCondominium => _selectedCondominio != null;

  CondominioService get _condominioService => CondominioService(token: _token);
  AlertaService get _alertaService => AlertaService(token: _token);
  AmenidadService get _amenidadService => AmenidadService(token: _token);

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
      _condominios = await _condominioService.listar();
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
      final nuevo = await _condominioService.crear(nombre, direccion);
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
      await _condominioService.eliminar(id);
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
      final actualizado = await _condominioService.actualizar(
        id,
        nombre,
        direccion,
      );
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

  Future<void> cargarAlertas({int? condominioId}) async {
    if (_token == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _alertas = await _alertaService.listarTodas(condominioId: condominioId);
    } catch (e) {
      _error = 'Error al cargar alertas';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> crearAlerta(
    String titulo,
    String mensaje,
    String prioridad,
    int condominioId,
    int creadoPorId, {
    String? fechaExpiracion,
  }) async {
    if (_token == null) return false;

    try {
      final nueva = await _alertaService.crear(
        titulo,
        mensaje,
        prioridad,
        condominioId,
        creadoPorId,
        fechaExpiracion: fechaExpiracion,
      );
      _alertas.insert(0, nueva);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al crear alerta';
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizarAlerta(
    int id,
    String titulo,
    String mensaje,
    String prioridad,
    int condominioId, {
    String? fechaExpiracion,
  }) async {
    if (_token == null) return false;

    try {
      final actualizada = await _alertaService.actualizar(
        id,
        titulo,
        mensaje,
        prioridad,
        condominioId,
        fechaExpiracion: fechaExpiracion,
      );
      final index = _alertas.indexWhere((a) => a.id == id);
      if (index != -1) {
        _alertas[index] = actualizada;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al actualizar alerta';
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarAlerta(int id) async {
    if (_token == null) return false;

    try {
      await _alertaService.eliminar(id);
      _alertas.removeWhere((a) => a.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al eliminar alerta';
      notifyListeners();
      return false;
    }
  }

  Future<void> cargarAmenidades({int? condominioId}) async {
    if (_token == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (condominioId != null) {
        _amenidades = await _amenidadService.listarPorCondominio(condominioId);
      }
    } catch (e) {
      _error = 'Error al cargar amenidades';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> crearAmenidad(
    String nombre,
    int condominioId,
    int? capacidadMaxima,
  ) async {
    if (_token == null) return false;

    try {
      await _amenidadService.crear(nombre, condominioId, capacidadMaxima);
      await cargarAmenidades(condominioId: condominioId);
      return true;
    } catch (e) {
      _error = 'Error al crear amenidad';
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizarAmenidad(
    int id,
    String nombre,
    int condominioId,
    int? capacidadMaxima,
  ) async {
    if (_token == null) return false;

    try {
      await _amenidadService.actualizar(
        id,
        nombre,
        condominioId,
        capacidadMaxima,
      );
      await cargarAmenidades(condominioId: condominioId);
      return true;
    } catch (e) {
      _error = 'Error al actualizar amenidad';
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarAmenidad(int id) async {
    if (_token == null) return false;

    try {
      await _amenidadService.eliminar(id);
      final condominioId = _selectedCondominio?.id;
      if (condominioId != null) {
        await cargarAmenidades(condominioId: condominioId);
      }
      return true;
    } catch (e) {
      _error = 'Error al eliminar amenidad';
      notifyListeners();
      return false;
    }
  }
}
