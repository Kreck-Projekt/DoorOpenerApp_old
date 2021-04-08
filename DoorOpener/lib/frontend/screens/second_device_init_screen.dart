import 'package:flutter/material.dart';
import 'package:qr_utils/qr_utils.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/init_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/password_set_screen.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';

import '../constants.dart';

class SecondDeviceInit extends StatelessWidget {
  static const routeName = 'second-device';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackgroundColor,
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(kDefaultPadding / 2),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)
                      .translate('second_device_explanation'),
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () async {
                    String readCredentials = await QrUtils.scanQR;
                    print(readCredentials);
                    bool wait =
                        await DataManager.handleQrData(readCredentials);
                    if (wait) {
                      Navigator.of(context).pop(SetPassword());
                      Navigator.of(context)
                          .pushReplacementNamed(InitApp.routeName);
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('second_device_continue'),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(.87),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
