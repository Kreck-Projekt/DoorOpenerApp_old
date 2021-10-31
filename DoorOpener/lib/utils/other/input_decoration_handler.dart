import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';

InputDecoration inputDecorationHandler(BuildContext context, String labelText, String hintText) {
  return InputDecoration(
    labelText: AppLocalizations.of(context).translate(
      labelText,
    ),
    hintText: AppLocalizations.of(context).translate(
      hintText,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );
}
