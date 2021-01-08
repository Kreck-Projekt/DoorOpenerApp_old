import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  Homescreen({Key key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  //
  Widget androidAppBar() {
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

  Widget androidButton() {
    return null;
  }

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

  Widget iosButton() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS ? iosAppBar() : androidAppBar(),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Platform.isIOS ? iosButton() : androidButton(),
          ),
        ),
      ),
    );
  }
}
