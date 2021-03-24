import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/change_ip_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/credits_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/password_auth_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/password_change_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/share_credentials_screen.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';

import '../constants.dart';

class Settings extends StatelessWidget {
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackgroundColor,
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).translate('settings_screen_title'),),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          child: Container(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                Card(
                  elevation: 8,
                  margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(
                          Icons.lock_outlined,
                          color: kDarkDefaultColor,
                        ),
                        title: Text(
                          AppLocalizations.of(context)
                              .translate('settings_screen_change_password'),
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.of(context).pushNamed(PasswordChange.routeName);
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.qr_code_outlined,
                          color: kDarkDefaultColor,
                        ),
                        title: Text(
                          AppLocalizations.of(context)
                              .translate('settings_screen_add_device'),
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(PasswordAuth.routeName, arguments: {
                            'hint': 'share_credentials_hint',
                            'explanation': 'share_credentials_explanation',
                            'label': 'share_credentials_label',
                            'route': ShareCredentials.routeName
                          });
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.api_outlined,
                          color: kDarkDefaultColor,
                        ),
                        title: Text(
                          AppLocalizations.of(context)
                              .translate('settings_screen_ip_change'),
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.of(context).pushNamed(ChangeIP.routeName);
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.app_settings_alt_outlined,
                          color: kDarkDefaultColor,
                        ),
                        title: Text(
                          AppLocalizations.of(context)
                              .translate('settings_screen_app_reset'),
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          DataManager().appReset(context);
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.arrow_back,
                          color: kDarkDefaultColor,
                        ),
                        title: Text(
                          AppLocalizations.of(context)
                              .translate('settings_screen_full_reset'),
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          DataManager().fullReset(context);
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      ListTile(
                          leading: const Icon(
                            Icons.account_circle_outlined,
                            color: kDarkDefaultColor,
                          ),
                          title: Text(
                            AppLocalizations.of(context)
                                .translate('credits_screen_title'),
                            style: Theme.of(context).textTheme.headline1.copyWith(
                                fontSize: 20, fontWeight: FontWeight.normal),
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.of(context).pushNamed(Credits.routeName);
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
