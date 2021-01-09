import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/utils/cryptography/key_manager.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';

import 'loading_screen.dart';

class SetPassword extends StatefulWidget {
  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();

  Widget _snackBar(String message) {
    return SnackBar(
      duration: Duration(seconds: 3),
      backgroundColor: Colors.redAccent,
      content: Text(
        AppLocalizations.of(context).translate(message),
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
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
                        .translate('set_password_explanation'),
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontSize: 20, fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  // SizedBox(height: 10,),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
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
                              labelStyle: Theme.of(context).textTheme.bodyText1,
                              labelText: AppLocalizations.of(context)
                                  .translate('set_password_password_label'),
                              hintStyle: Theme.of(context).textTheme.bodyText1,
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
                                  return AppLocalizations.of(context).translate(
                                      'set_password_password_mismatch');
                                } else
                                  return null;
                              } else
                                return AppLocalizations.of(context)
                                    .translate('set_password_password_short');
                              ;
                            },
                            decoration: InputDecoration(
                              labelStyle: Theme.of(context).textTheme.bodyText1,
                              labelText: AppLocalizations.of(context).translate(
                                  'set_password_confirm_password_label'),
                              hintStyle: Theme.of(context).textTheme.bodyText1,
                              hintText: AppLocalizations.of(context).translate(
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.tealAccent,
          onPressed: () async {
            print(_formKey.currentState.validate());
            if (_formKey.currentState.validate()) {
              await KeyManager().firstStart(_password2Controller.text.toString());
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => LoadingScreen()));
            } else
              return ScaffoldMessenger.of(context)
                  .showSnackBar(_snackBar('first_start_snackbar_message'));
          },
          child: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
