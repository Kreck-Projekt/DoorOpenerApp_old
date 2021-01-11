import 'package:raspberry_pi_door_opener/utils/cryptography/key_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This class handles the IP and Port Storage
class DataManager {
  // This Method safe the IP Address in the Shared Preferences
  Future<void> safeIP(String ipAddress) async {
    final _storage = await SharedPreferences.getInstance();
    _storage.setString('ipAddress', ipAddress);
  }

  // This Method get the IP Adress from the Shared Preferences
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

  Future<void> safeTime(int time) async {
    final _storage = await SharedPreferences.getInstance();
    _storage.setInt('time', time);
  }

  Future<int> getTime() async{
    final _storage = await SharedPreferences.getInstance();
    return _storage.getInt('time');
  }

  Future<bool> handleQrData(String data) async{
    int keyEnd , nonceEnd, hashEnd, ipEnd, portEnd, time, port;
    String key, hash, nonce, ipAdress;
    for(int i = 0; i < data.length; i++){
      if (data[i] == ';') {
        keyEnd = i;
        break;
      }
    }
    key = data.substring(0, keyEnd);
    print('key: $key');
    for(int i = keyEnd +1; i < data.length; i++){
      if (data[i] == ';') {
        hashEnd = i;
        break;
      }
    }
    hash = data.substring(keyEnd +1, hashEnd);
    print('hash: $hash');
    for(int i = hashEnd + 1; i < data.length; i++){
      if (data[i] == ';') {
        nonceEnd = i;
        break;
      }
    }
    nonce = data.substring(hashEnd +1, nonceEnd);
    print('nonce: $nonce');
    for(int i = nonceEnd +1; i < data.length; i++){
      if (data[i] == ';') {
        ipEnd = i;
        break;
      }
    }
    ipAdress = data.substring(nonceEnd +1, ipEnd);
    print('ipAdress: $ipAdress');
    for(int i = ipEnd +1; i < data.length; i++){
      if (data[i] == ';') {
        portEnd = i;
        break;
      }
    }
    port = int.parse(data.substring(ipEnd +1, portEnd));
    print('port: $port');
    time = int.parse(data.substring(portEnd+1));
    print(time);
    await KeyManager().safePasswordHexNonce(nonce);
    await KeyManager().safeHexKey(key);
    await KeyManager().safeHexPassword(hash);
    await DataManager().safeIP(ipAdress);
    await DataManager().safeTime(time);
    await DataManager().safePort(port);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('first', false);
    return true;
  }
}
