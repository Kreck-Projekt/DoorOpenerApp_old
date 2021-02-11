import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/snackbar.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/security/key_manager.dart';
import 'package:raspberry_pi_door_opener/utils/tcp/tcp_connection.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This class handles the Data for maintaining the app
class DataManager {
  // set the bool for the init class
  // is used to differentiate between password auth and password set screen
  Future<void> setFirst() async {
    final _storage = await SharedPreferences.getInstance();
    _storage.setBool('first', false);
  }

  // set the bool for the init class
  Future<bool> getFirst() async {
    final _storage = await SharedPreferences.getInstance();
    return _storage.getBool('first') ?? true;
  }

  // This Method safe the IP Address in the Shared Preferences
  Future<void> safeIP(String ipAddress) async {
    final _storage = await SharedPreferences.getInstance();
    _storage.setString('ipAddress', ipAddress);
  }

  // This Method get the IP Address from the Shared Preferences
  Future<String> getIpAddress() async {
    final _storage = await SharedPreferences.getInstance();
    return _storage.getString('ipAddress');
  }

  // This Method safe the Port in the Shared Preferences
  Future<void> safePort(int port) async {
    final _storage = await SharedPreferences.getInstance();
    _storage.setInt('port', port);
  }

  // This Method get the Port from the Shared Preferences
  Future<int> getPort() async {
    final _storage = await SharedPreferences.getInstance();
    return _storage.getInt('port');
  }

  // This Method safe the Default Open time which was set from the user during the setup
  Future<void> safeTime(int time) async {
    final _storage = await SharedPreferences.getInstance();
    _storage.setInt('time', time);
  }

  // This Method get the Default time from the Shared Preferences
  Future<int> getTime() async {
    final _storage = await SharedPreferences.getInstance();
    return _storage.getInt('time') ?? 2;
  }

  // This Method is called during the setup when the user allow local auth and the UserDevice have LocalAuth properties
  Future<void> safeLocalAuthAllowed() async {
    final _storage = await SharedPreferences.getInstance();
    _storage.setBool('localAuth', true);
  }

  // This Method is called during the setup when the UserDevice have no LocalAuth properties or the user don't allow LocalAuth
  Future<void> safeLocalAuthDisallowed() async {
    final _storage = await SharedPreferences.getInstance();
    _storage.setBool('localAuth', false);
  }

  // This Method get the State of the LocalAuth from the Shared PReferences
  Future<bool> getLocalAuth() async {
    final _storage = await SharedPreferences.getInstance();
    return _storage.getBool('localAuth');
  }

  // This Method handle the received QR Data from the main device
  Future<bool> handleQrData(String data) async {
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
    await KeyManager().safePasswordHexNonce(nonce);
    await KeyManager().safeHexKey(key);
    await KeyManager().safeHexPassword(hash);
    await DataManager().safeIP(ipAddress);
    await DataManager().safeTime(time);
    await DataManager().safePort(port);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('first', false);
    return true;
  }

  // This method handle an IP Reset
  Future<void> ipReset(String newIP) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ipAddress', newIP);
  }

  // This method handle an App and Server reset
  Future<void> fullReset(BuildContext context) async {
    bool success = await TCP().reset();
    if (success) {
      appReset(context);
    }
  }

  // This method handle an App reset
  Future<void> appReset(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    KeyManager().reset();
    prefs.setBool('first', true);
    Phoenix.rebirth(context);
  }

  //
  Future<bool> setInitialData(String ipAddress, int port, int  time) async{
    time *= 1000;
    print(time);
    await safeIP(ipAddress);
    await safePort(port);
    await safeTime(time);
    await setFirst();
    return true;
  }

  String generateOTP() {
      var random = Random.secure();
      var values = List<int>.generate(12, (i) =>  random.nextInt(255));
      return base64UrlEncode(values);
  }

  void handleOTP(BuildContext context) async{
    String otp = generateOTP();
    bool success = await TCP().otpSend(otp);
    if(success){
      String sharedMessage = AppLocalizations.of(context).translate('home_screen_share_otp');
      Share.share('$sharedMessage: $otp');
    }else snackBar('first_start_snackbar_message', context);
  }
}
