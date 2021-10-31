// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/error_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/snackbar.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';
import 'package:raspberry_pi_door_opener/utils/security/cryption.dart';
import 'package:raspberry_pi_door_opener/utils/security/key_manager.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';

class TCP {
  final KeyManager keyManager = KeyManager();

  // Handle the callback from the server and print it to the console
  void callback(String msg, BuildContext context) {
    debugPrint('Callback: $msg');
    final int errorCode = int.tryParse(msg);
    if (errorCode != 0) {
      if (errorCode == 01 ||
          errorCode == 02 ||
          errorCode == 03 ||
          errorCode == 05 ||
          errorCode == 06 ||
          errorCode == 07) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => ErrorScreen(
              errorCode: errorCode,
            ),
          ),
        );
      } else if (errorCode == 04 || errorCode == 08 || errorCode == 09 || errorCode == 10) {
        String errorMessage;
        switch (errorCode) {
          case 04:
            errorMessage = AppLocalizations.of(context).translate("error_screen_error_04");
            break;
          case 08:
            errorMessage = AppLocalizations.of(context).translate("error_screen_error_08");
            break;
          case 09:
            errorMessage = AppLocalizations.of(context).translate("error_screen_error_09");
            break;
          case 10:
            errorMessage = AppLocalizations.of(context).translate("error_screen_error_10");
            break;
        }
        snackBar(errorMessage, context);
      }
    }
  }

  // Send the Key to the Raspberry Pi for the encryption of the messages
  Future<bool> sendKey(BuildContext context) async {
    try {
      final String key = await keyManager.hexKey;
      return await _tcpConnectAndSend('k:$key', context);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // Send the hashedPassword to the Pi for comparing
  Future<bool> sendPassword(BuildContext context) async {
    try {
      final String hashedPassword = await keyManager.hexPassword;
      final encryptedPassword = await Cryption().encrypt(hashedPassword);
      return await _tcpConnectAndSend('p:$encryptedPassword', context);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> sendNonce(BuildContext context) async {
    final String nonce = await keyManager.hexNonce;
    final encryptedNonce = await Cryption().encrypt(nonce);
    return _tcpConnectAndSend('n:$encryptedNonce', context);
  }

  // Send the open command to the pi
  Future<bool> openDoor(int time, BuildContext context) async {
    try {
      final String hashedPassword = await keyManager.hexPassword;
      final String command = '$hashedPassword;$time';
      final String encryptedCommand = await Cryption().encrypt(command);
      return await _tcpConnectAndSend('o:$encryptedCommand', context);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // send the changePassword command
  Future<bool> changePassword(
    String oldHexPassword,
    BuildContext context,
  ) async {
    try {
      final String hashedPassword = await keyManager.hexPassword;
      final String encryptedOldNewPassword = await Cryption().encrypt('$oldHexPassword;$hashedPassword');
      return await _tcpConnectAndSend('c:$encryptedOldNewPassword', context);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // send a reset command to the server to reset the server
  Future<bool> reset(BuildContext context) async {
    try {
      final String hashedPassword = await keyManager.hexPassword;
      final String encryptedReset = await Cryption().encrypt(hashedPassword);
      return await _tcpConnectAndSend('r:$encryptedReset', context);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // send the otp to the server for comparing it later
  Future<bool> otpSend(String otp, BuildContext context) async {
    try {
      final String hashedPassword = await keyManager.hexPassword;
      final String encryptedOTP = await Cryption().encrypt('$hashedPassword;$otp');
      return await _tcpConnectAndSend('s:$encryptedOTP', context);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // send the otp and the open time to the server so that the server can compare it
  // with its stored otp codes and if it match it open the door
  Future<bool> otpOpen(String otp, int time, String ip, int port, BuildContext context) async {
    try {
      final TcpSocketConnection _tcpSocketConnection = TcpSocketConnection(ip, port);
      await _tcpSocketConnection.connect(5000, "EOS", (String msg) => callback(msg, context));
      _tcpSocketConnection.sendMessage('e:$otp;$time\n');
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // Establish connection to the Server and then send the msg/command
  Future<bool> _tcpConnectAndSend(String msg, BuildContext context) async {
    try {
      final String ip = await DataManager.ipAddress;
      final int port = await DataManager.port;
      final TcpSocketConnection _tcpSocketConnection = TcpSocketConnection(ip, port);
      _tcpSocketConnection.enableConsolePrint(true);
      //TODO: Remove following line for Online Test
      //return true;
      if (await _tcpSocketConnection.canConnect(1500)) {
        await _tcpSocketConnection.connect(5000, "EOS", (String message) => callback(message, context));
        _tcpSocketConnection.sendMessage('$msg\n');
        _tcpSocketConnection.disconnect();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
