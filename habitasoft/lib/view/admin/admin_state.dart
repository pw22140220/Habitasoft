import 'package:flutter/material.dart';
import '../../models/alerta_model.dart';
import '../../models/amenidad_model.dart';
import '../../models/anuncio_model.dart';
import '../../models/condominio_model.dart';
import '../../models/unidad_model.dart';
import '../../models/usuario_model.dart';
import '../../services/alerta_service.dart';
import '../../services/amenidad_service.dart';
import '../../services/anuncio_service.dart';
import '../../services/condominio_service.dart';
import '../../services/unidad_service.dart';
import '../../services/usuario_service.dart';

class AdminState extends ChangeNotifier {
  String? _token;
  Condominio? _selectedCondominio;
  List<Condominio> _condominios = [];
  List<Alerta> _alertas = [];
  List<Amenidad> _amenidades = [];
  List<Anuncio> _anuncios = [];
  List<Unidad> _unidades = [];
  List<Usuario> _usuarios = [];
  bool _isLoading = false;
  String? _error;

  Condominio? get selectedCondominio => _selectedCondominio;
  List<Condominio> get condominios => _condominios;
  List<Alerta> get alertas => _alertas;
  List<Amenidad> get amenidades => _amenidades;
  List<Anuncio> get anuncios => _anuncios;
  List<Usuario> get usuarios => _usuarios;
  List<Unidad> get unidades => _unidades;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;
  bool get hasSelectedCondominium => _selectedCondominio != null;

  CondominioService get _condominioService => CondominioService(token: _token);
  AlertaService get _alertaService => AlertaService(token: _token);
  AmenidadService get _amenidadService => AmenidadService(token: _token);
  AnuncioService get _anuncioService => AnuncioService(token: _token);
  UsuarioService get _usuarioService => UsuarioService(token: _token);
  UnidadService get _unidadService => UnidadService(token: _token);

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

  // ===================== USUARIOS =====================

  Future<void> cargarUsuarios({String? search}) async {
    if (_token == null || _selectedCondominio == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _usuarios = await _usuarioService.listar(
        _selectedCondominio!.id,
        search: search,
      );
    } catch (e) {
      _error = 'Error al cargar usuarios';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> crearUsuario(Map<String, dynamic> data) async {
    if (_token == null || _selectedCondominio == null) return false;

    try {
      final nuevo = await _usuarioService.crear(data, _selectedCondominio!.id);
      _usuarios.add(nuevo);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizarUsuario(int id, Map<String, dynamic> data) async {
    if (_token == null || _selectedCondominio == null) return false;

    try {
      final actualizado = await _usuarioService.actualizar(
        id,
        data,
        _selectedCondominio!.id,
      );
      final index = _usuarios.indexWhere((u) => u.id == id);
      if (index != -1) {
        _usuarios[index] = actualizado;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarUsuario(int id) async {
    if (_token == null) return false;

    try {
      await _usuarioService.eliminar(id);
      _usuarios.removeWhere((u) => u.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al eliminar usuario';
      notifyListeners();
      return false;
    }
  }

  List<Usuario> searchUsuarios(String query) {
    if (query.isEmpty) return _usuarios;
    final q = query.toLowerCase();
    return _usuarios.where((u) {
      return u.nombre.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q) ||
          (u.telefono != null && u.telefono!.toLowerCase().contains(q));
    }).toList();
  }

  // ===================== ANUNCIOS =====================

  Future<void> cargarAnuncios() async {
    if (_token == null || _selectedCondominio == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _anuncios = await _anuncioService.listar(_selectedCondominio!.id);
    } catch (e) {
      _error = 'Error al cargar anuncios';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> crearAnuncio(Map<String, dynamic> data) async {
    if (_token == null || _selectedCondominio == null) return false;
    try {
      final nuevo = await _anuncioService.crear(data, _selectedCondominio!.id);
      _anuncios.add(nuevo);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizarAnuncio(int id, Map<String, dynamic> data) async {
    if (_token == null) return false;
    try {
      final actualizado = await _anuncioService.actualizar(id, data);
      final index = _anuncios.indexWhere((a) => a.id == id);
      if (index != -1) {
        _anuncios[index] = actualizado;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarAnuncio(int id) async {
    if (_token == null) return false;
    try {
      await _anuncioService.eliminar(id);
      _anuncios.removeWhere((a) => a.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al eliminar anuncio';
      notifyListeners();
      return false;
    }
  }

  // ===================== UNIDADES =====================

  Future<void> cargarUnidades() async {
    if (_token == null || _selectedCondominio == null) return;
    try {
      _unidades = await _unidadService.listarPorCondominio(
        _selectedCondominio!.id,
      );
      notifyListeners();
    } catch (e) {
      _error = 'Error al cargar unidades';
      notifyListeners();
    }
  }

  Future<bool> crearUnidad(String numeroUnidad) async {
    if (_token == null || _selectedCondominio == null) return false;
    try {
      final nueva = await _unidadService.crear(
        numeroUnidad,
        _selectedCondominio!.id,
      );
      _unidades.add(nueva);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizarUnidad(int id, String numeroUnidad) async {
    if (_token == null || _selectedCondominio == null) return false;
    try {
      final actualizada = await _unidadService.actualizar(
        id,
        numeroUnidad,
        _selectedCondominio!.id,
      );
      final index = _unidades.indexWhere((u) => u.id == id);
      if (index != -1) {
        _unidades[index] = actualizada;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarUnidad(int id) async {
    if (_token == null) return false;
    try {
      await _unidadService.eliminar(id);
      _unidades.removeWhere((u) => u.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al eliminar unidad';
      notifyListeners();
      return false;
    }
  }
}
