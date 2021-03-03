import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';
import 'package:raspberry_pi_door_opener/utils/security/cryption.dart';
import 'package:raspberry_pi_door_opener/utils/security/key_manager.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';

class TCP {

  // Handle the callback from the server and print it to the console
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
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
      print(e);
      return false;
    }
  }

  // send a reset command to the server to reset the server
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
    } catch(e){
      print(e);
      return false;
    }
  }

  // send the otp to the server for comparing it later
  Future<bool> otpSend(String otp) async {
    try {
      String ip = await DataManager().getIpAddress();
      int port = await DataManager().getPort();
      String hashedPassword = await KeyManager().getHexPassword();
      String encryptedOTP = await Cryption().encrypt('$hashedPassword;$otp');
      final TcpSocketConnection _tcpSocketConnection = TcpSocketConnection(ip, port);
      await _tcpSocketConnection.connect(5000, "EOS", callback);
      _tcpSocketConnection.sendMessage('s:$encryptedOTP\n');
      return true;
    } catch(e){
      print(e);
      return false;
    }
  }

  // send the otp and the open time to the server so that the server can compare it
  // with its stored otp codes and if it match it open the door
  Future<bool> otpOpen(String otp, int time, String ip, int port) async {
    try {
      final TcpSocketConnection _tcpSocketConnection = TcpSocketConnection(ip, port);
      await _tcpSocketConnection.connect(5000, "EOS", callback);
      _tcpSocketConnection.sendMessage('e:$otp;$time\n');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
