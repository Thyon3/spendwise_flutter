import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();
      
      return canAuthenticateWithBiometrics && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  Future<bool> authenticate({
    String localizedReason = 'Authenticate to access your expense tracker',
    bool useErrorDialogs = true,
    bool stickyAuth = false,
    bool biometricOnly = false,
  }) async {
    try {
      final bool authenticated = await _auth.authenticate(
        localizedReason: localizedReason,
        useErrorDialogs: useErrorDialogs,
        stickyAuth: stickyAuth,
        biometricOnly: biometricOnly,
      );
      return authenticated;
    } on PlatformException catch (e) {
      print('Biometric authentication error: ${e.message}');
      return false;
    }
  }

  Future<void> enableBiometric() async {
    await _storage.write(key: 'biometric_enabled', value: 'true');
  }

  Future<void> disableBiometric() async {
    await _storage.delete(key: 'biometric_enabled');
  }

  Future<bool> isBiometricEnabled() async {
    final String? value = await _storage.read(key: 'biometric_enabled');
    return value == 'true';
  }

  Future<bool> authenticateWithBiometricOrPin() async {
    final bool isBiometricEnabled = await this.isBiometricEnabled();
    final bool isBiometricAvailable = await this.isBiometricAvailable();

    if (isBiometricEnabled && isBiometricAvailable) {
      return await authenticate(
        localizedReason: 'Use biometric authentication to access your account',
        biometricOnly: false,
      );
    }

    return false;
  }

  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: 'user_email', value: email);
    await _storage.write(key: 'user_password', value: password);
  }

  Future<Map<String, String>?> getSavedCredentials() async {
    final String? email = await _storage.read(key: 'user_email');
    final String? password = await _storage.read(key: 'user_password');

    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }

  Future<void> clearSavedCredentials() async {
    await _storage.delete(key: 'user_email');
    await _storage.delete(key: 'user_password');
  }

  Future<String> getBiometricType() async {
    final List<BiometricType> availableBiometrics = await getAvailableBiometrics();
    
    if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'fingerprint';
    } else if (availableBiometrics.contains(BiometricType.face)) {
      return 'face';
    } else if (availableBiometrics.contains(BiometricType.iris)) {
      return 'iris';
    }
    
    return 'unknown';
  }
}
