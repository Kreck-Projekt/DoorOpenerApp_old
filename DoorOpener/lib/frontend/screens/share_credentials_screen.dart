import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/models/otp.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';
import 'package:raspberry_pi_door_opener/utils/security/key_manager.dart';
import 'package:screenshot/screenshot.dart';

import '../constants.dart';

class ShareCredentials extends StatefulWidget {
  static const routeName = 'share-credentials';

  @override
  _ShareCredentialsState createState() => _ShareCredentialsState();
}

class _ShareCredentialsState extends State<ShareCredentials> {
  bool loaded = false;
  bool init = true;
  OTP otpModel;
  String payload;
  ScreenshotController screenshot = ScreenshotController();

  Future<void> initDevice() async {
    final KeyManager keyManager = KeyManager();
    final String tempKey = await keyManager.hexKey;
    final String tempPassword = await KeyManager().hexPassword;
    final Nonce nonce = await keyManager.passwordNonce;
    final String ipAddress = await DataManager.ipAddress;
    final int port = await DataManager.port;
    final int time = await DataManager.time;
    final String passwordNonce = hex.encode(nonce.bytes);
    payload = 'd:$tempKey;$tempPassword;$passwordNonce;$ipAddress;$port;$time';
    debugPrint('payload: $payload');
    setState(() {
      debugPrint('rdy');
      loaded = true;
    });
  }

  void initOTP() {
    payload =
    "o:${otpModel.otp};${otpModel.ip};${otpModel.port}";
    setState(() {
      debugPrint('rdy');
      loaded = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      final List<dynamic> args =  ModalRoute.of(context).settings.arguments as List<dynamic> ?? [];
      if (args != null) {
        otpModel = args[0] as OTP;
        initOTP();
      }  else {
        initDevice();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey key = GlobalKey();
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          child: Center(
            child: loaded
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Screenshot(
                          key: key,
                          controller: screenshot,
                          child: Container(
                            color: Colors.white,
                            height: 200,
                            width: 200,
                            margin: const EdgeInsets.fromLTRB(50, 50, 50, 50),
                            child: QrImage(
                              data: payload,
                              
                              size: 200,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          DataManager.takeScreenShot(
                            screenshot,
                            AppLocalizations.of(context).translate(
                              "share_credentials_share_qr",
                            ),
                          );
                        },
                        icon: const Icon(
                          CupertinoIcons.share,
                          color: Colors.white,
                        ),
                        label: const Text('Share'),
                      ),
                    ],
                  )
                : const Text('pls wait a moment'),
          ),
        ),
      ),
    );
  }
}
