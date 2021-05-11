import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/security/key_manager.dart';
import 'package:raspberry_pi_door_opener/utils/tcp/tcp_connection.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This class handles the Data for maintaining the app
class DataManager {
  /*
  --------------------------------------------
  Setters
  --------------------------------------------
   */

  // set the bool for the init class
  // is used to differentiate between password auth and password set screen
  static Future<void> setFirst() async {
    final _storage = await SharedPreferences.getInstance();
    print('settingThisUp');
    _storage.setBool('first', false);
  }

  // This Method safe the IP Address in the Shared Preferences
  static Future<void> safeIP(String ipAddress) async {
    final _storage = await SharedPreferences.getInstance();
    _storage.setString('ipAddress', ipAddress);
  }

  // This Method safe the Port in the Shared Preferences
  static Future<void> safePort(int port) async {
    final _storage = await SharedPreferences.getInstance();
    _storage.setInt('port', port);
  }

  // This Method safe the Default Open time which was set from the user during the setup
  static Future<void> safeTime(int time) async {
    final _storage = await SharedPreferences.getInstance();
    _storage.setInt('time', time);
  }

  // Save Fatal Error that User can not use the app
  // Mostly to prevent unwanted behaviour of the App and the RaspiOpener
  static void setErrorCode(int errorCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('errorCode', errorCode);
  }

  /*
  --------------------------------------------
  Getters
  --------------------------------------------
   */

  // set the bool for the init class
  static Future<bool> get first async {
    final _storage = await SharedPreferences.getInstance();
    bool init = _storage.getBool('first') ?? true;
    print(init);
    return init;
  }

  // This Method get the IP Address from the Shared Preferences
  static Future<String> get ipAddress async {
    final _storage = await SharedPreferences.getInstance();
    return _storage.getString('ipAddress');
  }

  // This Method get the Port from the Shared Preferences
  static Future<int> get port async {
    final _storage = await SharedPreferences.getInstance();
    return _storage.getInt('port');
  }

  // This Method get the Default time from the Shared Preferences
  static Future<int> get time async {
    final _storage = await SharedPreferences.getInstance();
    return _storage.getInt('time') ?? 2;
  }

  // Get the error code for blocking app until reset
  static Future<int> get errorCode async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('errorCode') ?? 0;
  }

  /*
  --------------------------------------------
  Helpers
  --------------------------------------------
   */

  // This method handle an IP Reset
  static Future<void> ipReset(String newIP) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ipAddress', newIP);
  }

  // This method handle an App and Server reset
  static Future<void> fullReset(BuildContext context) async {
    bool success = await TCP().reset(context);
    if (success) {
      appReset(context);
    }
  }

  // This method handle an App reset
  static Future<void> appReset(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await KeyManager().reset();
    prefs.setBool('first', true);
    Phoenix.rebirth(context);
  }

  // Create a OTP for one Time opening
  static String generateOTP() {
    final random = Random.secure();
    final values = List<int>.generate(12, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  // Handle the Sharing Process of the OTP
  static Future<bool> handleOTP(BuildContext ctx) async {
    String otp = generateOTP();
    bool success = await TCP().otpSend(otp, ctx);
    final ipAddressStore = await ipAddress;
    final portStore = await port;
    print(success);
    if (success) {
      String sharedMessage =
          AppLocalizations.of(ctx).translate('home_screen_share_otp');
      Share.share(
          '$sharedMessage \nOTP: $otp \nIP: $ipAddressStore \nPort: $portStore');
      return true;
    } else
      return false;
  }

  // Set all data which is required for the SetUp
  // Call 4 Methods in DataManager to keep other code simple and clean
  static Future<bool> setInitialData(
      String ipAddress, int port, int time) async {
    time *= 1000;
    print(time);
    await safeIP(ipAddress);
    await safePort(port);
    await safeTime(time);
    await setFirst();
    return true;
  }

  // Handle the screenshot for Qr Code share
  static Future<bool> takeScreenShot(
      ScreenshotController screenshot, String msg) async {
    try {
      final directory = (await getApplicationDocumentsDirectory()).path;
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final path = '$directory';
      var result =
          await screenshot.captureAndSave(path, fileName: '$fileName.png');
      print(path);
      print(result.toString());
      Share.shareFiles(
        ['$path/$fileName.png'],
        text: "$msg",
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // This Method handle the received QR Data from the main device
  static Future<bool> handleQrData(String data) async {
    int keyEnd, nonceEnd, hashEnd, ipEnd, portEnd, time, port;
    String key, hash, nonce, ipAddress;
    for (int i = 0; i < data.length; i++) {
      if (data[i] == ';') {
        keyEnd = i;
        break;
      }
    }
    key = data.substring(0, keyEnd);
    print('key: $key');
    for (int i = keyEnd + 1; i < data.length; i++) {
      if (data[i] == ';') {
        hashEnd = i;
        break;
      }
    }
    hash = data.substring(keyEnd + 1, hashEnd);
    print('hash: $hash');
    for (int i = hashEnd + 1; i < data.length; i++) {
      if (data[i] == ';') {
        nonceEnd = i;
        break;
      }
    }
    nonce = data.substring(hashEnd + 1, nonceEnd);
    print('nonce: $nonce');
    for (int i = nonceEnd + 1; i < data.length; i++) {
      if (data[i] == ';') {
        ipEnd = i;
        break;
      }
    }
    ipAddress = data.substring(nonceEnd + 1, ipEnd);
    print('ipAddress: $ipAddress');
    for (int i = ipEnd + 1; i < data.length; i++) {
      if (data[i] == ';') {
        portEnd = i;
        break;
      }
    }
    port = int.parse(data.substring(ipEnd + 1, portEnd));
    print('port: $port');
    time = int.parse(data.substring(portEnd + 1));
    print(time);
    KeyManager().qrData(nonce, key, hash);
    setInitialData(ipAddress, port, time);
    setFirst();
    return true;
  }
}
