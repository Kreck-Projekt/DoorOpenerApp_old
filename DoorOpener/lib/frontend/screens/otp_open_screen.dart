import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/snackbar.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/other/inputDecorationHandler.dart';
import 'package:raspberry_pi_door_opener/utils/tcp/tcp_connection.dart';

import '../constants.dart';

class OtpOpenScreen extends StatefulWidget {
  static const routeName = '/opt-open';

  @override
  _OtpOpenScreenState createState() => _OtpOpenScreenState();
}

class _OtpOpenScreenState extends State<OtpOpenScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  final _openTimeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _openTimeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkDefaultColor,
        appBar: AppBar(
          title: Text('OTP Open'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('otp_screen_explain'),
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            fontSize: 20, fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyText1,
                              controller: _otpController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return AppLocalizations.of(context)
                                      .translate('otp_screen_otp_hint');
                                }
                                return null;
                              },
                              decoration: inputDecorationHandler(context, 'otp_screen_otp_label', 'otp_screen_otp_hint'),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyText1,
                              controller: _ipController,
                              keyboardType: TextInputType.number,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String value) {
                                //return ipValidator(value, context);
                                return null;
                              },
                              decoration: inputDecorationHandler(context, 'first_start_ip_label', 'first_start_ip_hint'),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyText1,
                              controller: _portController,
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
                              decoration: inputDecorationHandler(context, 'first_start_port_label', 'first_start_port_hint'),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyText1,
                              controller: _openTimeController,
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
                                'first_start_open_hint',
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
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
                  String ipAddress = _ipController.text.toString();
                  int port = int.parse(_portController.text.toString());
                  int time = int.parse(_openTimeController.text.toString());
                  time *= 1000;
                  String otp = _otpController.text.toString();
                  if (await TCP().otpOpen(otp, time, ipAddress, port, ctx)) {
                    Navigator.of(context).pop();
                  } else
                    return snackBar('first_start_snackbar_message', ctx);
                } else
                  return snackBar('first_start_snackbar_message', ctx);
              },
              child: Icon(Icons.arrow_forward, color: Colors.white.withOpacity(.87),),
            );
          },
        ));
  }
}
