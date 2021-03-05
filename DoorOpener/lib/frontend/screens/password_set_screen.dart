import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/second_device_init_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/snackbar.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/security/auth_handler.dart';

class SetPassword extends StatefulWidget {
  static const routeName = 'password-set';

  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();


  @override
  void dispose() {
    super.dispose();
    _password1Controller.dispose();
    _password2Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate('set_password_welcome'),
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('set_password_explanation'),
                      style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: 20, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
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
                            obscureText: true,
                            style: Theme.of(context).textTheme.bodyText1,
                            controller: _password1Controller,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return AppLocalizations.of(context)
                                    .translate('set_password_password_hint');
                              } else if (value.length <= 7) {
                                return AppLocalizations.of(context)
                                    .translate('set_password_password_hint');
                              } else
                                return null;
                            },
                            decoration: InputDecoration(
                              labelStyle:
                                  Theme.of(context).textTheme.bodyText1,
                              labelText: AppLocalizations.of(context)
                                  .translate('set_password_password_label'),
                              hintStyle:
                                  Theme.of(context).textTheme.bodyText1,
                              hintText: AppLocalizations.of(context)
                                  .translate('set_password_password_hint'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            obscureText: true,
                            style: Theme.of(context).textTheme.bodyText1,
                            controller: _password2Controller,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return AppLocalizations.of(context)
                                    .translate('set_password_password_hint');
                              } else if (value.length >= 7) {
                                if (_password1Controller.text !=
                                    _password2Controller.text) {
                                  return AppLocalizations.of(context)
                                      .translate(
                                          'set_password_password_mismatch');
                                } else
                                  return null;
                              } else
                                return AppLocalizations.of(context)
                                    .translate('set_password_password_short');
                            },
                            decoration: InputDecoration(
                              labelStyle:
                                  Theme.of(context).textTheme.bodyText1,
                              labelText: AppLocalizations.of(context)
                                  .translate(
                                      'set_password_confirm_password_label'),
                              hintStyle:
                                  Theme.of(context).textTheme.bodyText1,
                              hintText: AppLocalizations.of(context)
                                  .translate(
                                      'set_password_confirm_password_hint'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 25),
            Text(
              AppLocalizations.of(context)
                  .translate('set_password_second_device'),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontSize: 20, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => SecondDeviceInit(),
                  ),
                );
              },
              child: Icon(
                Icons.qr_code,
                size: 40,
              ),
            ),
          ],
        ),
      ]),
      floatingActionButton: Builder(
        builder: (BuildContext ctx) {
          return FloatingActionButton(
            backgroundColor: Colors.tealAccent,
            onPressed: () async {
              print(_formKey.currentState.validate());
              if (_formKey.currentState.validate()) {
                String password = _password2Controller.text.toString();
                await AuthHandler().setPassword(password, ctx);
              } else
                return snackBar('first_start_snackbar_message', ctx);
            },
            child: Icon(Icons.arrow_forward),
          );
        },
      )
    );
  }
}
