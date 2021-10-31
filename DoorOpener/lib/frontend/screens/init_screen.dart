// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/constants.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/error_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/password_auth_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/password_set_screen.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';

import 'home_screen.dart';

class InitApp extends StatefulWidget {
  static const routeName = '/init';

  @override
  _InitAppState createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final bool first = await DataManager.first;
    final int errorCode = await DataManager.errorCode;
    debugPrint(first.toString());
    if (errorCode != 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => ErrorScreen(
            errorCode: errorCode,
          ),
        ),
      );
    } else if (first) {
      Navigator.of(context).pushReplacementNamed(SetPassword.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(
        PasswordAuth.routeName,
        arguments: {
          'route': Homescreen.routeName,
          'label': 'password_auth_password_label',
          'explanation': 'password_auth_explanation',
          'hint': 'password_auth_password_hint',
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackgroundColor,
      body: Center(
        child: Icon(
          Icons.vpn_key_outlined,
          size: 200,
          color: Colors.white.withOpacity(.87),
        ),
      ),
    );
  }
}
