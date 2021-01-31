import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricHandler {
  LocalAuthentication auth = LocalAuthentication();

  Future<bool> checkBiometric() async {
    bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
    return canCheckBiometric;
  }

  Future<List<BiometricType>> getAvailableBiometric() async {
    List<BiometricType> availableBiometric;
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
      return null;
    }
    return availableBiometric;
  }

  Future<bool> authenticate(String localizedReason) async {
    bool authenticated;
    print('biach;_;');
    try {
      authenticated = await auth.authenticateWithBiometrics(
        localizedReason: localizedReason,
        useErrorDialogs: true,
        stickyAuth: false,
      );
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
    return authenticated;
  }
}
// TODO: Implement functions in password auth or auth_handler
