import 'package:flutter/material.dart';

Widget androidAppBar(context) {
  return AppBar(
    title: Text(
      'DoorOpener',
      style: Theme.of(context)
          .textTheme
          .headline1
          .copyWith(fontSize: 20, fontWeight: FontWeight.bold,),
    ),
    actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})],
  );
}