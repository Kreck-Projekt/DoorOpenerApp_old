// ignore_for_file: prefer_typing_uninitialized_variables, type_annotate_public_apis

import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

import 'key_manager.dart';

// This class Manage the Encryption and Password Hashing
class Cryption {
  final Cipher _cipher = aesGcm;
  var encrypted;

  // Encrypt every TCP Message which is send to the PI
  Future<String> encrypt(String msg) async {
    final SecretKey secretKey = await KeyManager().secretKey;
    final tempMsg = utf8.encode(msg);
    final Nonce nonce = _cipher.newNonce();
    final encrypted = await _cipher.encrypt(
      tempMsg,
      secretKey: secretKey,
      nonce: nonce,
    );
    final Uint8List uint8nonce = nonce.bytes as Uint8List;
    final hexNonce = hex.encode(uint8nonce);
    final encryptedHex = hex.encode(encrypted);
    final encryptedHexNonce = '$encryptedHex;$hexNonce';
    return encryptedHexNonce;
  }

  // Hash the User Password with PBKDF2 Algorithm
  Future<List<int>> passwordHash(String password, Nonce nonce ) async {
    if (nonce == null) {
      // ignore: parameter_assignments
      nonce = _cipher.newNonce();
      KeyManager().safePasswordNonce(nonce);
    }
    const pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac(sha256),
      iterations: 5000,
      bits: 128,
    );
    final hashPassword =
        await pbkdf2.deriveBits(utf8.encode(password), nonce: nonce);
    return hashPassword;
  }
}
