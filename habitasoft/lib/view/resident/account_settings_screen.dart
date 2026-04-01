import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import '../auth/home_screen.dart';
import '../../services/biometric_preferences_service.dart';

// Pantalla de Configuración de Cuenta - Con funcionalidades
class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Cargar preferencias desde shared_preferences
  Future<void> _loadPreferences() async {
    final darkModeEnabled =
        await BiometricPreferencesService.getDarkModeEnabled();
    setState(() => _isDarkMode = darkModeEnabled);
  }

  // Guardar preferencia de modo oscuro
  Future<void> _saveDarkModePreference(bool value) async {
    await BiometricPreferencesService.setDarkModeEnabled(value);
    setState(() => _isDarkMode = value);
  }

  // Eliminar cuenta
  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar Cuenta'),
            content: const Text(
              '¿Estás seguro de que deseas eliminar tu cuenta? '
              'Esta acción eliminará todos tus datos locales y no se puede deshacer.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      // Limpiar shared_preferences
      await BiometricPreferencesService.clearUserData();

      if (!mounted) return;

      // Navegar al login original
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuenta eliminada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Cuenta'),
        backgroundColor: const Color(0xFF0A896E),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección: Perfil y Seguridad
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF555555),
                  ),
                  title: const Text(
                    'Editar Perfil',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(
                    Icons.lock_outline,
                    color: Color(0xFF555555),
                  ),
                  title: const Text(
                    'Cambiar Contraseña',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sección: Apariencia
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.dark_mode_outlined,
                color: Color(0xFF555555),
              ),
              title: const Text(
                'Modo Oscuro',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Switch(
                value: _isDarkMode,
                activeColor: const Color(0xFF0B64D8),
                onChanged: (value) {
                  _saveDarkModePreference(value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value
                            ? 'Modo oscuro activado'
                            : 'Modo oscuro desactivado',
                      ),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Botón de Eliminar Cuenta
          Center(
            child: TextButton.icon(
              onPressed: _deleteAccount,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: const Text(
                'Eliminar Cuenta',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
