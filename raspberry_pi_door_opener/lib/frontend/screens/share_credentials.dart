import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:convert/convert.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:raspberry_pi_door_opener/utils/cryptography/key_manager.dart';

class ShareCredentials extends StatefulWidget {


  @override
  _ShareCredentialsState createState() => _ShareCredentialsState();
}

class _ShareCredentialsState extends State<ShareCredentials> {
  bool loaded = false;
  String payload;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init()async{
    String tempKey = await KeyManager().getHexKey();
    String tempPassword = await KeyManager().getHexPassword();
    Nonce nonce = await KeyManager().getPasswordNonce();
    String passwordNonce = hex.encode(nonce.bytes);
    payload = '$tempKey;$tempPassword;$passwordNonce';
    print('payload: $payload');
    setState(() {
      print('rdy');
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: loaded ? QrImage(
            data: payload,
            version: QrVersions.auto,
            size: 200.0,
          ) : Text('pls wait a moment')
        ),
      ),
    );
  }
}
