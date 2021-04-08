import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/password_set_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/snackbar.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';
import 'package:raspberry_pi_door_opener/utils/other/inputDecorationHandler.dart';

import '../constants.dart';
import 'loading_screen.dart';

class SetInitalData extends StatefulWidget {
  static const routeName = '/set-inital-data';

  @override
  _SetInitalDataState createState() => _SetInitalDataState();
}

class _SetInitalDataState extends State<SetInitalData> {
  final _formKey = GlobalKey<FormState>();
  final ipController = TextEditingController();
  final portController = TextEditingController();
  final openController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackgroundColor,
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          child: SingleChildScrollView(child: Builder(
            builder: (BuildContext ctx) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate('first_start_explanation'),
                      style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: 20, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                    // SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 50.0, horizontal: 10.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyText1,
                              controller: ipController,
                              keyboardType: TextInputType.number,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String value) {
                                //return ipValidator(value, context);
                                return null;
                              },
                              decoration: inputDecorationHandler(
                                  context,
                                  'first_start_ip_label',
                                  'first_start_ip_hint'),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyText1,
                              controller: portController,
                              keyboardType: TextInputType.number,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return AppLocalizations.of(context)
                                      .translate('first_start_port_validate');
                                } else
                                  return null;
                              },
                              decoration: inputDecorationHandler(
                                  context,
                                  'first_start_port_label',
                                  'first_start_port_hint'),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyText1,
                              controller: openController,
                              keyboardType: TextInputType.number,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return AppLocalizations.of(context)
                                      .translate('first_start_open_validate');
                                } else
                                  return null;
                              },
                              decoration: inputDecorationHandler(
                                  context,
                                  'first_start_open_label',
                                  'first_start_open_hint'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext ctx) {
          return FloatingActionButton(
            backgroundColor: kDarkDefaultColor,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                String ipAddress = ipController.text.toString();
                int port = int.parse(portController.text.toString());
                int time = int.parse(openController.text.toString());
                bool success =
                    await DataManager.setInitialData(ipAddress, port, time);
                if (success) {
                  DataManager.setFirst();
                  Navigator.of(context).pop(SetPassword);
                  Navigator.of(context)
                      .pushReplacementNamed(LoadingScreen.routeName);
                } else
                  return snackBar('first_start_snackbar_message', ctx);
              } else
                return snackBar('first_start_snackbar_message', ctx);
            },
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white.withOpacity(.87),
            ),
          );
        },
      ),
    );
  }
}
