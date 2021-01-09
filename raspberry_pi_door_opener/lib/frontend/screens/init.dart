import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/first_start.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/homescreen.dart';
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
    bool first = prefs.getBool('first');
    if (first) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => FirstStart()));
    }  else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => Homescreen()));
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
