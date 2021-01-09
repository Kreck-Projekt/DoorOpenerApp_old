import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

import 'key_manager.dart';

// This class Manage the Encryption and Password Hashing
class Cryption {
  final Cipher _cipher = aesGcm;
  var encrypted;

  // Encrypt every TCP Message which is send to the PI
  Future<String> encrypt(msg) async {
    SecretKey secretKey = await KeyManager().getSecretKey();
    Nonce nonce = await KeyManager().getNonce();
    final encrypted = await _cipher.encrypt(
      msg,
      secretKey: secretKey,
      nonce: nonce,
    );
    var encryptedHex = hex.encode(encrypted);
    return encryptedHex;
  }

  // Hash the User Password with PBKDF2 Algorithm
  Future<String> passwordHash(String password) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac(sha256),
      iterations: 100000,
      bits: 128,
    );
    final Nonce nonce = await KeyManager().getNonce();
    final hashBytes =
        await pbkdf2.deriveBits(utf8.encode('$password'), nonce: nonce);
    String hashPassword = hashBytes.toString();
    return hashPassword;
  }
}
