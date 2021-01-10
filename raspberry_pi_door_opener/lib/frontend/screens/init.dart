import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/homescreen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/password_auth.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/set_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitApp extends StatefulWidget {
  @override
  _InitAppState createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool first = prefs.getBool('first')  ?? true;
    if (first) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => SetPassword()));
    }  else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => PasswordAuth(route: Homescreen(), label: 'password_auth_password_label', explanation: 'password_auth_explanation', hint: 'password_auth_password_hint',)));
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Icon(
            Icons.vpn_key_outlined,
            size: 200,
          ),
        ),
      ),
    );
  }
}
