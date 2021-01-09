import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';

// This Method Validate the inserted IP-Address from the user
String ipValidator(String value, context) {
  if (value.isEmpty) {
    return AppLocalizations.of(context)
        .translate('first_start_ip_validate');
  } else if (value.length - 1 >= 3 ?? false) {
    if (value[3] == '.' ?? false) {
      if (value.length - 1 >= 7 ?? false) {
        if (value[7] == '.' ?? false) {
          return null;
        } else
          return AppLocalizations.of(context)
              .translate(
              'first_start_ip_validate');
      } else
        return AppLocalizations.of(context)
            .translate('first_start_ip_validate');
    } else
      return AppLocalizations.of(context)
          .translate('first_start_ip_validate');
  } else
    return AppLocalizations.of(context)
        .translate('first_start_ip_validate');
}