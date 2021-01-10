import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/init.dart';

import 'utils/localizations/app_localizations.dart';

void main() => runApp(MyApp());

// TODO: Add QR-Code Setup(for 2. or more Devices) + Settings Slide Up
// TODO: Add Explanation Screen

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Door Opener',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.black12,
        fontFamily: 'Merriweather',
        textTheme: ThemeData.dark().textTheme.copyWith(
              headline1: TextStyle(
                fontFamily: 'Merriweather',
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
              bodyText1: TextStyle(
                fontFamily: 'Merriweather',
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
      ),
      darkTheme: ThemeData.dark(),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('de', 'DE'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      // ignore: missing_return
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: InitApp(),
    );
  }
}
