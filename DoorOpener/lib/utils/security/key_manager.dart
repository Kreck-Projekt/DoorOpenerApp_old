import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'cryption.dart';

// Manage SecretKey, Nonce and Password
class KeyManager {
  final _storage = const FlutterSecureStorage();
  static const cipher = aesGcm;

  /*
  --------------------------------------------
  Setters
  --------------------------------------------
   */

  // Safe an Hex Converted Key
  Future<void> safeHexKey(String hexKey) async {
    await _storage.write(key: 'hexKey', value: hexKey);
  }

  // Safe an Hex Converted Password Nonce
  Future<void> safePasswordHexNonce(String hexNonce) async {
    await _storage.write(key: 'hexNonce', value: hexNonce);
  }

  // Safe an Hex Password
  Future<void> safeHexPassword(String hexPassword) async {
    await _storage.write(key: 'hashedPassword', value: hexPassword);
  }

  // Safe the password nonce for comparing at login
  Future<void> safePasswordNonce(Nonce nonce) async {
    await _storage.write(key: 'hexNonce', value: hex.encode(nonce.bytes));
  }

  /*
  --------------------------------------------
  Getters
  --------------------------------------------
   */

  // Return an String with the HashedPassword
  Future<String> get hexPassword async {
    return _storage.read(key: 'hashedPassword');
  }

  // Return an Object of Type SecretKey
  Future<SecretKey> get secretKey async {
    return SecretKey(hex.decode(await _storage.read(key: 'hexKey')));
  }

  // Return an String with the HexKey
  Future<String> get hexKey async {
    return _storage.read(key: 'hexKey');
  }

  // Get the password nonce for comparing at the login
  Future<Nonce> get passwordNonce async {
    return Nonce(hex.decode(await _storage.read(key: 'hexNonce')));
  }

  // Get the password nonce as string
  Future<String> get hexNonce async {
    return _storage.read(key: 'hexNonce');
  }

  /*
  --------------------------------------------
  Helpers
  --------------------------------------------
   */

  // Change the password in the encrypted storage
  Future<void> changePassword(String newHashPassword) async {
    await _storage.write(key: 'hashedPassword', value: newHashPassword);
  }

  // Init the Password Hashing, Nonce Generation and SecretKey Generation
  // Store them in SecuredStorage
  Future<bool> firstStart(String password) async {
    final secretKey = cipher.newSecretKeySync(length: 16);
    final Uint8List uint8Key = secretKey.extractSync() as Uint8List;
    final hexKey = hex.encode(uint8Key);
    await _storage.write(key: 'hexKey', value: hexKey);
    final hashPassword = await Cryption().passwordHash(password, null);
    await _storage.write(
      key: 'hashedPassword',
      value: hex.encode(hashPassword),
    );
    return true;
  }

  // Handle the Key Data from the Qr Code
  Future<void> qrData(String nonce, String key, String hash) async {
    await KeyManager().safePasswordHexNonce(nonce);
    await KeyManager().safeHexKey(key);
    await KeyManager().safeHexPassword(hash);
  }

  // delete everything in the storage
  Future<void> reset() async {
    await _storage.deleteAll();
  }
}
