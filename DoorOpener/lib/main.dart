import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:raspberry_pi_door_opener/frontend/screens/change_ip_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/credits_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/home_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/init_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/loading_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/onboarding_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/otp_add_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/password_auth_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/password_change_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/password_set_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/second_device_init_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/set_initial_data_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/settings_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/share_credentials_screen.dart';
import 'frontend/constants.dart';
import 'frontend/screens/saved_qr_codes_screen.dart';
import 'utils/localizations/app_localizations.dart';

// TODO: QR Image Export implementation
// TODO: QR Gallery Read
// TODO: Add OTP open button to password auth and welcome screen
// TODO: UI 2.0
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

// TODO: Add Explanation Screen

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Door Opener',
      theme: ThemeData.dark().copyWith(
        primaryColor: kDarkDefaultColor,
        backgroundColor: kDarkBackgroundColor,
        textTheme: TextTheme(
          headline1: TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white.withOpacity(.87),
          ),
          bodyText1: TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.normal,
            fontSize: 15,
            color: Colors.white.withOpacity(.55),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              20,
            ),
            borderSide: BorderSide(
              color: kDarkDefaultColor.withOpacity(.9),
            ),
          ),
          focusColor: kDarkDefaultColor,
          fillColor: kDarkDefaultColor,
          labelStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.white.withOpacity(.87),
              ),
          hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.white.withOpacity(.55),
              ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black12),
      ),
      supportedLocales: languages,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // ignore: missing_return
      localeResolutionCallback: (locale, supportedLocales) {
        for (final supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: SavedQRCodesScreen(),
      routes: {
        ChangeIP.routeName: (ctx) => ChangeIP(),
        Credits.routeName: (ctx) => Credits(),
        Homescreen.routeName: (ctx) => const Homescreen(),
        InitApp.routeName: (ctx) => InitApp(),
        LoadingScreen.routeName: (ctx) => LoadingScreen(),
        OnboardingScreen.routeName: (ctx) => OnboardingScreen(),
        OtpOpenScreen.routeName: (ctx) => OtpOpenScreen(),
        PasswordAuth.routeName: (ctx) => PasswordAuth(),
        PasswordChange.routeName: (ctx) => PasswordChange(),
        SetPassword.routeName: (ctx) => SetPassword(),
        SecondDeviceInit.routeName: (ctx) => SecondDeviceInit(),
        SetInitalData.routeName: (ctx) => SetInitalData(),
        Settings.routeName: (ctx) => Settings(),
        ShareCredentials.routeName: (ctx) => ShareCredentials(),
      },
    );
  }
}
