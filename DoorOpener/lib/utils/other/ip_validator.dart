import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:string_validator/string_validator.dart';

// This Method Validate the inserted IP-Address from the user
String ipValidator(String value, BuildContext context) {
  if (value.isEmpty) {
    return AppLocalizations.of(context).translate('first_start_ip_validate');
  }
  final bool valid = isIP(value);
  if (valid) {
    return null;
  } else {
    return AppLocalizations.of(context).translate('first_start_ip_validate');
  }
}
