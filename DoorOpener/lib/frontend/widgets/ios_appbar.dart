import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/settings_screen.dart';

Widget iosAppBar(BuildContext context) {
  return CupertinoNavigationBar(
    // middle: Text(
    //   'DoorOpener',
    //   style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 20, fontWeight: FontWeight.normal),
    // ),
    trailing: CupertinoButton(
      child: Icon(CupertinoIcons.settings),
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(Settings.routeName);
      },
    ),
  );
}
