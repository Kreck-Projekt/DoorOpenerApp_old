import 'package:shared_preferences/shared_preferences.dart';

// This class handles the IP and Port Storage
class DataManager{

  // This Method safe the IP Address in the Shared Preferences
  void safeIP(String ipAddress) async{
    final _storage = await SharedPreferences.getInstance();
    _storage.setString('ipAddress', ipAddress);
  }

  // This Method get the IP Adress from the Shared Preferences
  Future<String> getIpAddress() async{
    final _storage = await SharedPreferences.getInstance();
    return _storage.getString('ipAddress');
  }

  // This Method safe the Port in the Shared Preferences
  void safePort(int port) async{
    final _storage = await SharedPreferences.getInstance();
    _storage.setInt('port', port);
  }

  // This Method get the Port from the Shared Preferences
  Future<int> getPort() async{
    final _storage = await SharedPreferences.getInstance();
    return _storage.getInt('port');
  }
}