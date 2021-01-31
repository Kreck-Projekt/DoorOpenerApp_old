import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/settings.dart';

Widget iosAppBar(BuildContext context) {
  return CupertinoNavigationBar(
    leading: const Text(
      'DoorOpener',
    ),
    trailing: CupertinoButton(
      child: Icon(CupertinoIcons.settings),
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => Settings()));
      },
    ),
  );
}
