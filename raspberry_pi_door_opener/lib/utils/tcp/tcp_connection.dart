
import 'package:cryptography/cryptography.dart';
import 'package:raspberry_pi_door_opener/utils/cryptography/cryption.dart';
import 'package:raspberry_pi_door_opener/utils/cryptography/key_manager.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';

class TCP{
  void messageReceived(String msg, String ipAddress, int port)async {
    final TcpSocketConnection _tcpSocketConnection = TcpSocketConnection(ipAddress, port);
    _tcpSocketConnection.enableConsolePrint(true);
    await _tcpSocketConnection.connect(5000,"EOS", callback);
    _tcpSocketConnection.sendMessage('$msg\n');
  }
  
  void callback(String msg){
    print('Callback: $msg');
  }
  
  Future<bool> sendKey() async {
    try {
      String ip = await DataManager().getIpAddress();
      int port = await DataManager().getPort();
      SecretKey key = await KeyManager().getSecretKey();
      final TcpSocketConnection _tcpSocketConnection = TcpSocketConnection(
          ip, port);
      _tcpSocketConnection.enableConsolePrint(true);
      await _tcpSocketConnection.connect(5000, "EOS", callback);
      _tcpSocketConnection.sendMessage('k:$key');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendNonce() async {
    try {
      String ip = await DataManager().getIpAddress();
      int port = await DataManager().getPort();
      Nonce nonce = await KeyManager().getNonce();
      final TcpSocketConnection _tcpSocketConnection = TcpSocketConnection(
          ip, port);
      _tcpSocketConnection.enableConsolePrint(true);
      await _tcpSocketConnection.connect(5000, "EOS", callback);
      _tcpSocketConnection.sendMessage('n:$nonce');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendPassword() async {
    try {
      String ip = await DataManager().getIpAddress();
      int port = await DataManager().getPort();
      String hashedPassword = await KeyManager().getHashPassword();
      String encryptedPassword = await Cryption().encrypt('p:$hashedPassword');
      final TcpSocketConnection _tcpSocketConnection = TcpSocketConnection(
          ip, port);
      _tcpSocketConnection.enableConsolePrint(true);
      await _tcpSocketConnection.connect(5000, "EOS", callback);
      _tcpSocketConnection.sendMessage(encryptedPassword);
      return true;
    } catch (e) {
      return false;
    }
  }

}