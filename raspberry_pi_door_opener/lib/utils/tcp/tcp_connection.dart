import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:raspberry_pi_door_opener/utils/cryptography/cryption.dart';
import 'package:raspberry_pi_door_opener/utils/cryptography/key_manager.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';

class TCP{
  
  void callback(String msg){
    print('Callback: $msg');
  }
  
  Future<bool> sendKey() async {
    try {
      String ip = await DataManager().getIpAddress();
      int port = await DataManager().getPort();
      String key = await KeyManager().getHexKey();
      final TcpSocketConnection _tcpSocketConnection = TcpSocketConnection(
          ip, port);
      _tcpSocketConnection.enableConsolePrint(true);
      await _tcpSocketConnection.connect(5000, "EOS", callback);
      await Future.delayed(Duration(seconds: 1));
      _tcpSocketConnection.sendMessage('k:$key\n');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendNonce() async {
    try {
      String ip = await DataManager().getIpAddress();
      int port = await DataManager().getPort();
      String nonce = await KeyManager().getHexNonce();
      final TcpSocketConnection _tcpSocketConnection = TcpSocketConnection(
          ip, port);
      _tcpSocketConnection.enableConsolePrint(true);
      await _tcpSocketConnection.connect(5000, "EOS", callback);
      await Future.delayed(Duration(seconds: 1));
      _tcpSocketConnection.sendMessage('n:$nonce\n');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendPassword() async {
    try {
      String ip = await DataManager().getIpAddress();
      int port = await DataManager().getPort();
      String hashedPassword = await KeyManager().getHexPassword();
      var encryptedPassword = await Cryption().encrypt('$hashedPassword');
      final TcpSocketConnection _tcpSocketConnection = TcpSocketConnection(
          ip, port);
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

  Future<bool> openDoor(int time) async{
    try {
      String ip = await DataManager().getIpAddress();
      int port = await DataManager().getPort();
      String hashedPassword = await KeyManager().getHexPassword();
      String command = '$hashedPassword;$time';
      String encryptedCommand = await Cryption().encrypt(command);
      final TcpSocketConnection _tcpSocketConnection = TcpSocketConnection(
          ip, port);
      _tcpSocketConnection.enableConsolePrint(true);
      await _tcpSocketConnection.connect(5000, "EOS", callback);
      _tcpSocketConnection.sendMessage('o:$encryptedCommand\n');
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

}
