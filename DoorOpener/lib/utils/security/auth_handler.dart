import 'dart:typed_data';
import 'package:convert/convert.dart';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/initial_data_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/password_change_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/snackbar.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';
import 'package:raspberry_pi_door_opener/utils/tcp/tcp_connection.dart';


import 'biometric_handler.dart';
import 'cryption.dart';
import 'key_manager.dart';

class AuthHandler {
  Future<void> passwordAuth(String insertedPassword, route, BuildContext context) async {
    final Nonce nonce = await KeyManager().getPasswordNonce();
    String hashedPassword =
    hex.encode(await Cryption().passwordHash(insertedPassword, nonce));
    String hexPassword = await KeyManager().getHexPassword();
    if (hashedPassword == hexPassword) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => route()));
    } else
      return Scaffold.of(context)
          .showSnackBar(snackBar('first_start_snackbar_message', context));
  }

  Future<void> setPassword(String password, BuildContext context) async{
    KeyManager().firstStart(password);
    List<BiometricType> availableAuth =
        await BiometricHandler().getAvailableBiometric();
    print('availableAuth: $availableAuth');
    if (availableAuth.isNotEmpty || availableAuth != null) {
      bool temp = await BiometricHandler().checkBiometric();
      print(temp);
      if (temp) {
        bool authSuccess =
            await BiometricHandler().authenticate('test');
        if (authSuccess) {
          print(authSuccess);
          DataManager().safeLocalAuthAllowed();
        } else
          DataManager().safeLocalAuthDisallowed();
      } else
        DataManager().safeLocalAuthDisallowed();
    } else
      DataManager().safeLocalAuthDisallowed();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => InitalData()));
  }

  Future<void> changePassword(String oldPassword, String newPasswordString, BuildContext context) async{
    Nonce nonce = await KeyManager().getPasswordNonce();
    Uint8List oldListPassword = await Cryption()
        .passwordHash(oldPassword, nonce);
    String oldHexPassword = hex.encode(oldListPassword);
    String oldStoredPassword = await KeyManager().getHexPassword();
    print('oldHexPassword: $oldHexPassword');
    print('oldStoredPassword: $oldStoredPassword');
    if (oldHexPassword == oldStoredPassword) {
      Uint8List newPassword = await Cryption()
          .passwordHash(newPasswordString, null);
      String newHexPassword = hex.encode(newPassword);
      KeyManager().changePassword(newHexPassword);
      bool test = await TCP().changePassword(oldHexPassword);
      if (test) {
        Navigator.of(context).pop(MaterialPageRoute(
            builder: (BuildContext context) => PasswordChange()));
      } else {
        print('test not true');
        return Scaffold.of(context)
            .showSnackBar(snackBar('first_start_snackbar_message', context));
      }
    } else {
      print('old and new Password !=');
      return Scaffold.of(context)
          .showSnackBar(snackBar('first_start_snackbar_message', context));
    }
  }
}


