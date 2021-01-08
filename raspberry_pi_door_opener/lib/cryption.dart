import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import 'key_manager.dart';


// This class Manage the Encryption and Password Hashing
class Cryption {
  var decryptionTest = utf8.encode("If you can read this I fucked up");
  var encrypted;
  var encrypted2;

  // Encrypt every TCP Message which is send to the PI
  encrypt(cipher, secretKey, nonce) async {
    final encrypted = await cipher.encrypt(
      decryptionTest,
      secretKey: secretKey,
      nonce: nonce,
    );
    return encrypted;
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
