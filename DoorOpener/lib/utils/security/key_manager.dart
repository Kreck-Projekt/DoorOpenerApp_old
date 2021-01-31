import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'cryption.dart';

// Manage SecretKey, Nonce and Password
class KeyManager {
  final _storage = FlutterSecureStorage();
  static const cipher = aesGcm;

  // Init the Password Hashing, Nonce Generation and SecretKey Generation
  // Store them in SecuredStorage
  Future<bool> firstStart(String password) async {
    final secretKey = cipher.newSecretKeySync(length: 16);
    final Uint8List uint8Key = secretKey.extractSync();
    final hexKey = hex.encode(uint8Key);
    await _storage.write(key: 'hexKey', value: hexKey);
    final hashPassword = await Cryption().passwordHash(password, null);
    await _storage.write(
        key: 'hashedPassword', value: hex.encode(hashPassword));
    return true;
  }

  void reset() {
    _storage.deleteAll();
  }

  // Return an Object of Type SecretKey
  Future<SecretKey> getSecretKey() async {
    return new SecretKey(hex.decode(await _storage.read(key: 'hexKey')));
  }

  // Return an String with the HexKey
  Future<String> getHexKey() async {
    return await _storage.read(key: 'hexKey');
  }

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

  // Return an String with the HashedPassword
  Future<String> getHexPassword() async {
    return await _storage.read(key: 'hashedPassword');
  }

  // Change the password in the encrypted storage
  void changePassword(String newHashPassword) async {
    await _storage.write(key: 'hashedPassword', value: newHashPassword);
  }

  // Safe the password nonce for comparing at login
  void safePasswordNonce(Nonce nonce) async {
    await _storage.write(key: 'hexNonce', value: hex.encode(nonce.bytes));
  }

  // Get the password nonce for comparing at the login
  Future<Nonce> getPasswordNonce() async {
    return Nonce(hex.decode(await _storage.read(key: 'hexNonce')));
  }
}
