import 'package:flutter/material.dart';
import 'frontend/screens/homescreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Door Opener',
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: 'Merriweather',
        textTheme: ThemeData.dark().textTheme.copyWith(
          headline1: TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      darkTheme: ThemeData.dark(),
      home: Homescreen(),
    );
  }
}