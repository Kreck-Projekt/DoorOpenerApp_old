import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'frontend/screens/homescreen.dart';
import 'utils/localizations/app_localizations.dart';

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
      home: Homescreen(),
    );
  }
}
