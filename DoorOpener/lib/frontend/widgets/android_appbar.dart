import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/settings_screen.dart';

PreferredSizeWidget androidAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).primaryColor,
    title: Text(
      'DoorOpener',
      style: Theme.of(context).textTheme.headline1.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(.87),
          ),
    ),
    actions: [
      IconButton(
        icon: Icon(
          Icons.settings,
          color: Colors.white.withOpacity(.87),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(Settings.routeName);
        },
      ),
    ],
  );
}
