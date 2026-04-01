import 'package:shared_preferences/shared_preferences.dart';

// Servicio para manejar preferencias locales (shared_preferences)
class BiometricPreferencesService {
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _darkModeEnabledKey = 'dark_mode_enabled';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userUnitKey = 'user_unit';

  // ===== BIOMETRÍA =====

  // Guardar estado de biometría
  static Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, enabled);
  }

  // Obtener estado de biometría
  static Future<bool> getBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false;
  }

  // ===== MODO OSCURO =====

  // Guardar estado de modo oscuro
  static Future<void> setDarkModeEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeEnabledKey, enabled);
  }

  // Obtener estado de modo oscuro
  static Future<bool> getDarkModeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeEnabledKey) ?? false;
  }

  // ===== DATOS DEL USUARIO (MOCK) =====

  // Guardar nombre del usuario
  static Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  // Obtener nombre del usuario
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey) ?? 'Juan Pérez';
  }

  // Guardar email del usuario
  static Future<void> setUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  // Obtener email del usuario
  static Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey) ?? 'juan.perez@condominio.com';
  }

  // Guardar unidad del usuario
  static Future<void> setUserUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userUnitKey, unit);
  }

  // Obtener unidad del usuario
  static Future<String> getUserUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userUnitKey) ?? 'Torre A - Apto 301';
  }

  // ===== LIMPIAR DATOS (para eliminar cuenta) =====

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_biometricEnabledKey);
    await prefs.remove(_darkModeEnabledKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userUnitKey);
  }
}
