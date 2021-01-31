import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/settings.dart';

Widget androidAppBar(context) {
  return AppBar(
    title: Text(
      'DoorOpener',
      style: Theme.of(context).textTheme.headline1.copyWith(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    actions: [
      IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Settings()));
          })
    ],
  );
}
