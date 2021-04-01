import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';
import 'package:raspberry_pi_door_opener/utils/security/key_manager.dart';

import '../constants.dart';

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
    DataManager data = DataManager();
    KeyManager keyManager = KeyManager();
    String tempKey = await keyManager.hexKey;
    String tempPassword = await KeyManager().hexPassword;
    Nonce nonce = await keyManager.passwordNonce;
    String ipAddress = await data.ipAddress;
    int port = await data.port;
    int time = await data.time;
    String passwordNonce = hex.encode(nonce.bytes);
    payload = '$tempKey;$tempPassword;$passwordNonce;$ipAddress;$port;$time';
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
      backgroundColor: kDarkBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
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
                            onPressed: () async {},
                            icon: Icon(CupertinoIcons.share, color: kDarkDefaultColor,),
                            label: Text('Share'),
                        ),
                      ],
                    )
                  : Text('pls wait a moment'),
            ),
          ),
        ),
      ),
    );
  }
}
