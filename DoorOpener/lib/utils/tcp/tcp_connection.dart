import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';
import 'package:raspberry_pi_door_opener/utils/security/cryption.dart';
import 'package:raspberry_pi_door_opener/utils/security/key_manager.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';

// TODO: Add Comments
class TCP {
  void callback(String msg) {
    print('Callback: $msg');
  }

  // Send the Key to the Raspberry Pi for the encryption of the messages
  Future<bool> sendKey() async {
    try {
      String ip = await DataManager().getIpAddress();
      int port = await DataManager().getPort();
      String key = await KeyManager().getHexKey();
      final TcpSocketConnection _tcpSocketConnection =
          TcpSocketConnection(ip, port);
      _tcpSocketConnection.enableConsolePrint(true);
      await _tcpSocketConnection.connect(5000, "EOS", callback);
      await Future.delayed(Duration(seconds: 1));
      _tcpSocketConnection.sendMessage('k:$key\n');
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  // Send the hashedPassword to the Pi for comparing
  Future<bool> sendPassword() async {
    try {
      String ip = await DataManager().getIpAddress();
      int port = await DataManager().getPort();
      String hashedPassword = await KeyManager().getHexPassword();
      var encryptedPassword = await Cryption().encrypt('$hashedPassword');
      final TcpSocketConnection _tcpSocketConnection =
          TcpSocketConnection(ip, port);
      _tcpSocketConnection.enableConsolePrint(true);
      await _tcpSocketConnection.connect(5000, "EOS", callback);
      await Future.delayed(Duration(seconds: 1));
      _tcpSocketConnection.sendMessage('p:$encryptedPassword\n');
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  // Send the open command to the pi
  Future<bool> openDoor(int time) async {
    try {
      String ip = await DataManager().getIpAddress();
      int port = await DataManager().getPort();
      String hashedPassword = await KeyManager().getHexPassword();
      String command = '$hashedPassword;$time';
      String encryptedCommand = await Cryption().encrypt(command);
      final TcpSocketConnection _tcpSocketConnection =
          TcpSocketConnection(ip, port);
      _tcpSocketConnection.enableConsolePrint(true);
      await _tcpSocketConnection.connect(5000, "EOS", callback);
      _tcpSocketConnection.sendMessage('o:$encryptedCommand\n');
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  // send the changePassword command
  Future<bool> changePassword(String oldHexPassword) async {
    try {
      String ip = await DataManager().getIpAddress();
      int port = await DataManager().getPort();
      String hashedPassword = await KeyManager().getHexPassword();
      String encryptedOldNewPassword = await Cryption().encrypt('$oldHexPassword;$hashedPassword');
      final TcpSocketConnection _tcpSocketConnection =
          TcpSocketConnection(ip, port);
      _tcpSocketConnection.enableConsolePrint(true);
      await _tcpSocketConnection.connect(5000, "EOS", callback);
      _tcpSocketConnection.sendMessage('c:$encryptedOldNewPassword\n');
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> reset() async {
    try {
      String ip = await DataManager().getIpAddress();
      int port = await DataManager().getPort();
      String hashedPassword = await KeyManager().getHexPassword();
      String encrptedReset = await Cryption().encrypt(hashedPassword);
      final TcpSocketConnection _tcpSocketConnection = TcpSocketConnection(ip, port);
      await _tcpSocketConnection.connect(5000, "EOS", callback);
      _tcpSocketConnection.sendMessage('r:$encrptedReset\n');
      return true;
    } on Exception catch(e){
      print(e);
      return false;
    }
  }


  Future<bool> otpSend(int otp) async {
    try {
      String ip = await DataManager().getIpAddress();
      int port = await DataManager().getPort();
      String hashedPassword = await KeyManager().getHexPassword();
      String encryptedOTP = await Cryption().encrypt('$hashedPassword;$otp');
      final TcpSocketConnection _tcpSocketConnection = TcpSocketConnection(ip, port);
      await _tcpSocketConnection.connect(5000, "EOS", callback);
      _tcpSocketConnection.sendMessage('r:$encryptedOTP\n');
      return true;
    } on Exception catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> otpOpen() async {
    // TODO: Implement method
  }
}
