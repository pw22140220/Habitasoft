import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

// Servicio para manejar autenticación biométrica (huella/Face ID)
class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Verificar si el dispositivo soporta autenticación biométrica
  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print('Error verificando disponibilidad biométrica: $e');
      return false;
    }
  }

  // Obtener los tipos de biometría disponibles
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('Error obteniendo biometrías disponibles: $e');
      return [];
    }
  }

  // Autenticar al usuario con biometría
  Future<bool> authenticate() async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return false;
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Autentícate para acceder a Habitasoft',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      return authenticated;
    } on PlatformException catch (e) {
      print('Error en autenticación biométrica: $e');
      return false;
    }
  }

  // Verificar si el dispositivo tiene Face ID disponible
  Future<bool> hasFaceId() async {
    final availableBiometrics = await getAvailableBiometrics();
    return availableBiometrics.contains(BiometricType.face);
  }

  // Verificar si el dispositivo tiene huella digital disponible
  Future<bool> hasFingerprint() async {
    final availableBiometrics = await getAvailableBiometrics();
    return availableBiometrics.contains(BiometricType.fingerprint);
  }

  // Obtener mensaje descriptivo de la biometría disponible
  Future<String> getBiometricTypeMessage() async {
    if (await hasFaceId()) {
      return 'Face ID';
    } else if (await hasFingerprint()) {
      return 'huella digital';
    } else {
      return 'autenticación biométrica';
    }
  }
}
