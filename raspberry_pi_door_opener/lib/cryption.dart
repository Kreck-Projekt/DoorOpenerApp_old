import 'dart:convert';

import 'package:cryptography/cryptography.dart';

class Cryption {
  var decryptionTest = utf8.encode("If you can read this I fucked up");


  var encrypted;
  var encrypted2;

  encrypt(cipher, secretKey, nonce) async {
    print('______________________________________');
    print('Encryption');
    print('Message: $decryptionTest');
    print('Cipher: $cipher');
    print('${secretKey.extractSync()}');
    print('nonce: $nonce');

    final encrypted = await cipher.encrypt(
      decryptionTest,
      secretKey: secretKey,
      nonce: nonce,
    );
    print('encryptedMessage: $encrypted');

    print('______________________________________');
    return encrypted;
  }

  void decrypt(temp, cipher, secretKey, nonce) async {
    encrypted2 = temp;
    print('______________________________________');
    print('Decryption');
    print('Message: $decryptionTest');
    print('Cipher: $cipher');
    print('secretKey: $secretKey');
    print('nonce: $nonce');
    print('encrypted : $encrypted2');
    var tempDecrypted =
        await cipher.decrypt(encrypted2, secretKey: secretKey, nonce: nonce);
    var decrypted = utf8.decode(tempDecrypted);
    print('decryptedMessage: $decrypted');
    print('______________________________________');
  }
}
