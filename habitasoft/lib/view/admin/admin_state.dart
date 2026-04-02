import 'package:flutter/material.dart';

// Modelo para representar un condominio
class Condominium {
  final String id;
  final String name;
  final String address;
  final int totalResidents;
  final String imageUrl;

  Condominium({
    required this.id,
    required this.name,
    required this.address,
    required this.totalResidents,
    required this.imageUrl,
  });
}

// Estado global del administrador usando ChangeNotifier
class AdminState extends ChangeNotifier {
  Condominium? _selectedCondominium;
  List<Condominium> _condominiums = [];

  // Mock data para condominios
  AdminState() {
    _condominiums = [
      Condominium(
        id: '1',
        name: 'Torre Central',
        address: 'Av. Principal 123',
        totalResidents: 150,
        imageUrl: '',
      ),
      Condominium(
        id: '2',
        name: 'Residencial Las Palmas',
        address: 'Calle Secundaria 456',
        totalResidents: 80,
        imageUrl: '',
      ),
      Condominium(
        id: '3',
        name: 'Condominio El Mirador',
        address: 'Boulevard Norte 789',
        totalResidents: 120,
        imageUrl: '',
      ),
      Condominium(
        id: '4',
        name: 'Edificio Horizonte',
        address: 'Plaza Central 101',
        totalResidents: 200,
        imageUrl: '',
      ),
    ];
  }

  // Getter para el condominio seleccionado
  Condominium? get selectedCondominium => _selectedCondominium;

  // Getter para la lista de condominios
  List<Condominium> get condominiums => _condominiums;

  // Método para seleccionar un condominio
  void selectCondominium(Condominium condominium) {
    _selectedCondominium = condominium;
    notifyListeners();
  }

  // Método para deseleccionar el condominio
  void clearSelectedCondominium() {
    _selectedCondominium = null;
    notifyListeners();
  }

  // Método para verificar si hay un condominio seleccionado
  bool get hasSelectedCondominium => _selectedCondominium != null;
}
