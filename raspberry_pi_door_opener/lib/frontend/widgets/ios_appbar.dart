import 'package:flutter/cupertino.dart';

Widget iosAppBar() {
  return CupertinoNavigationBar(
    leading: const Text(
      'DoorOpener',
    ),
    trailing: CupertinoButton(
      child: Icon(CupertinoIcons.settings),
      onPressed: () {},
    ),
  );
}