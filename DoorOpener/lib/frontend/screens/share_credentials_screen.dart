import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';
import 'package:raspberry_pi_door_opener/utils/security/key_manager.dart';
import 'package:share/share.dart';

class ShareCredentials extends StatefulWidget {
  static const routeName = 'share-credentials';

  @override
  _ShareCredentialsState createState() => _ShareCredentialsState();
}

class _ShareCredentialsState extends State<ShareCredentials> {
  bool loaded = false;
  String payload;
  GlobalKey _renderObjectKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    String tempKey = await KeyManager().getHexKey();
    String tempPassword = await KeyManager().getHexPassword();
    Nonce nonce = await KeyManager().getPasswordNonce();
    String ipAdress = await DataManager().getIpAddress();
    int port = await DataManager().getPort();
    int time = await DataManager().getTime();
    String passwordNonce = hex.encode(nonce.bytes);
    payload = '$tempKey;$tempPassword;$passwordNonce;$ipAdress;$port;$time';
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
      body: SafeArea(
        child: Container(
          child: Center(
            child: loaded
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: RepaintBoundary(
                          key: _renderObjectKey,
                          child: Container(
                            height: 200,
                            width: 200,
                            margin: EdgeInsets.fromLTRB(50, 50, 50, 50),
                            child: QrImage(
                              data: payload,
                              version: QrVersions.auto,
                              size: 200,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                          onPressed: () async {
                          },
                          icon: Icon(CupertinoIcons.share),
                          label: Text('Share')),
                    ],
                  )
                : Text('pls wait a moment'),
          ),
        ),
      ),
    );
  }
}
