import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';

snackBar(String message, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 3),
      backgroundColor: Colors.redAccent,
      content: Center(
        child: Text(
          AppLocalizations.of(context).translate(message),
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ),
  );
}
