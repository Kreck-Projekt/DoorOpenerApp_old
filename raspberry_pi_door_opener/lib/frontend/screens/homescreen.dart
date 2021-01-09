import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/android_appbar.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/ios_appbar.dart';

class Homescreen extends StatefulWidget {
  Homescreen({Key key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  //

  Widget androidButton() {
    return null;
  }

  Widget iosButton() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: Platform.isIOS ? iosAppBar() : androidAppBar(context),
        body: Container(
          child: Center(
            child: Platform.isIOS ? iosButton() : androidButton(),
          ),
        ),
      ),
    );
  }
}
