import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cryption.dart';

// Manage SecretKey, Nonce and Password
class KeyManager {
  final _storage = FlutterSecureStorage();
  static const cipher = aesGcm;

  // Init the Password Hashing, Nonce Generation and SecretKey Generation
  // Store them in SecuredStorage
  Future<bool> firstStart(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool first = prefs.getBool('first') ?? true;
    if (first) {
      final secretKey = cipher.newSecretKeySync(length: 16);
      final nonce = cipher.newNonce();
      final Uint8List uint8Key = secretKey.extractSync();
      final Uint8List uint8Nonce = nonce.bytes;
      final hexKey = hex.encode(uint8Key);
      final hexNonce = hex.encode(uint8Nonce);
      await _storage.write(key: 'hexKey', value: hexKey);
      await _storage.write(key: 'hexNonce', value: hexNonce);
      final hashPassword = await Cryption().passwordHash(password);
      final hexPassword = hex.encode(hashPassword);
      await _storage.write(key: 'hashedPassword', value: hexPassword);
      prefs.setBool('first', false);
      return true;
    }
    return true;
  }

  void reset() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('first', true);
    _storage.deleteAll();
  }

  // Return an Object of Type SecretKey
  Future<SecretKey> getSecretKey() async {
    var hexSecretKey = await _storage.read(key: 'hexKey');
    List<int> intKey = hex.decode(hexSecretKey);
    SecretKey secretKey = new SecretKey(intKey);
    return secretKey;
  }

  // Return an Object of Type Nonce
  Future<Nonce> getNonce() async {
    final hexNonce = await _storage.read(key: 'hexNonce');
    List<int> intNonce = hex.decode(hexNonce);
    Nonce nonce = new Nonce(intNonce);
    return nonce;
  }

  // Return an String with the HexKey
  Future<String> getHexKey() async {
    return await _storage.read(key: 'hexKey');
  }

  // Return an String with the HexNonce
  Future<String> getHexNonce() async {
    return await _storage.read(key: 'hexNonce');
  }

  // Return an String with the HashedPassword
  Future<String> getHexPassword() async {
    return await _storage.read(key: 'hashedPassword');
  }
}
