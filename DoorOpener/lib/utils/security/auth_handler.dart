// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/password_change_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/set_initial_data_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/snackbar.dart';
import 'package:raspberry_pi_door_opener/utils/tcp/tcp_connection.dart';

import 'cryption.dart';
import 'key_manager.dart';

class AuthHandler {
  Future<void> passwordAuth(String insertedPassword, String route, BuildContext context) async {
    final Nonce nonce = await KeyManager().passwordNonce;
    final String hashedPassword = hex.encode(await Cryption().passwordHash(insertedPassword, nonce));
    final String hexPassword = await KeyManager().hexPassword;
    if (hashedPassword == hexPassword) {
      Navigator.of(context).pushReplacementNamed(route);
    } else {
      return snackBar('first_start_snackbar_message', context);
    }
  }

  Future<void> setPassword(String password, BuildContext context) async {
    KeyManager().firstStart(password);
    Navigator.of(context).pushNamed(SetInitalData.routeName);
  }

  Future<void> changePassword(String oldPassword, String newPasswordString, BuildContext context) async {
    final Nonce nonce = await KeyManager().passwordNonce;
    final Uint8List oldListPassword = await Cryption().passwordHash(oldPassword, nonce) as Uint8List;
    final String oldHexPassword = hex.encode(oldListPassword);
    final String oldStoredPassword = await KeyManager().hexPassword;
    if (oldHexPassword == oldStoredPassword) {
      final Uint8List newPassword = await Cryption().passwordHash(newPasswordString, null) as Uint8List;
      final String newHexPassword = hex.encode(newPassword);
      KeyManager().changePassword(newHexPassword);
      final bool test = await TCP().changePassword(oldHexPassword, context);
      final bool test2 = await TCP().sendNonce(context);
      if (test) {
        if (test2) {
          Navigator.of(context).pop(
            MaterialPageRoute(
              builder: (BuildContext context) => PasswordChange(),
            ),
          );
        } else {
          debugPrint('wasnt able to send nonce');
          return snackBar('first_start_snackbar_message', context);
        }
      } else {
        debugPrint('test not true');
        return snackBar('first_start_snackbar_message', context);
      }
    } else {
      debugPrint('old and new Password !=');
      return snackBar('first_start_snackbar_message', context);
    }
  }
}
