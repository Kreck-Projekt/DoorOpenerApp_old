import 'dart:convert';


import 'package:tcp_socket_connection/tcp_socket_connection.dart';

class TCP{
  final TcpSocketConnection _tcpSocketConnection = TcpSocketConnection("192.168.0.14", 5000);



  void messageReceived(msg)async {
    _tcpSocketConnection.enableConsolePrint(true);
    await _tcpSocketConnection.connect(5000,"EOS", callback);
    _tcpSocketConnection.sendMessage('$msg\n');
  }
  void callback(String msg){
    print('Callback: $msg');
    _tcpSocketConnection.sendMessage('test\n');
  }

}