import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/homescreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Door Opener',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Merriweather',
        textTheme: ThemeData.dark().textTheme.copyWith(
          headline1: TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white
          ),
        ),
      ),
      darkTheme: ThemeData.dark(),
      home: Homescreen(),
    );
  }
}