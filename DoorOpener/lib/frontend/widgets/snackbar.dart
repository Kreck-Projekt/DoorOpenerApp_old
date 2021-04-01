import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';

snackBar(String message, BuildContext context) {
  return Fluttertoast.showToast(
    toastLength: Toast.LENGTH_SHORT,
    msg: AppLocalizations.of(context).translate(message),
    backgroundColor: Colors.red,
    textColor: Colors.white.withOpacity(.87),
    fontSize: 16.0,
  );
}
