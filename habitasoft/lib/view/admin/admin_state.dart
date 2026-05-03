import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/mock_backend_store.dart';

// Estado global del administrador usando ChangeNotifier
class AdminState extends ChangeNotifier {
  Condominium? _selectedCondominium;

  AdminState();

  // Getter para el condominio seleccionado
  Condominium? get selectedCondominium => _selectedCondominium;

  // Getter para la lista de condominios (obtenida del MockBackendStore)
  List<Condominium> getCondominiums(BuildContext context) {
    final store = Provider.of<MockBackendStore>(context, listen: false);
    return store.condominiums;
  }

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
