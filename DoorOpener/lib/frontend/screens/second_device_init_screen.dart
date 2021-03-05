import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/init_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/password_set_screen.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';

class SecondDeviceInit extends StatelessWidget {
  static const routeName = 'second-device';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  AppLocalizations.of(context)
                      .translate('second_device_explanation'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 20, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () async {
                  String readCredentials =
                      await FlutterBarcodeScanner.scanBarcode(
                          "#f66666",
                          AppLocalizations.of(context)
                              .translate('second_device_cancel'),
                          true,
                          ScanMode.QR);
                  print(readCredentials);
                  bool wait = await DataManager().handleQrData(readCredentials);
                  if (wait) {
                    Navigator.of(context).pop(SetPassword());
                    Navigator.of(context).pushReplacementNamed(InitApp.routeName);
                  }
                },
                child: Text(
                  AppLocalizations.of(context)
                      .translate('second_device_continue'),
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
