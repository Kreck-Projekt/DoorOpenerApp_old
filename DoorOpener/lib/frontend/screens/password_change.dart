import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/homescreen.dart';
import 'package:raspberry_pi_door_opener/utils/security/cryption.dart';
import 'package:raspberry_pi_door_opener/utils/security/key_manager.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/tcp/tcp_connection.dart';

class PasswordChange extends StatefulWidget {
  @override
  _PasswordChangeState createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmController = TextEditingController();

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
        appBar: AppBar(),
        body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('change_password_explanation'),
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
                              SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                obscureText: true,
                                style: Theme.of(context).textTheme.bodyText1,
                                controller: _oldPasswordController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return AppLocalizations.of(context)
                                        .translate(
                                            'change_password_old_password_hint');
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  labelText: AppLocalizations.of(context)
                                      .translate(
                                          'change_password_old_password_label'),
                                  hintStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  hintText: AppLocalizations.of(context)
                                      .translate(
                                          'change_password_old_password_hint'),
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
                                controller: _newPasswordController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return AppLocalizations.of(context)
                                        .translate(
                                            'change_password_password_hint');
                                  } else if (value.length <= 7) {
                                    return AppLocalizations.of(context)
                                        .translate(
                                            'change_password_password_hint');
                                  } else
                                    return null;
                                },
                                decoration: InputDecoration(
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  labelText: AppLocalizations.of(context)
                                      .translate(
                                          'change_password_password_label'),
                                  hintStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  hintText: AppLocalizations.of(context)
                                      .translate(
                                          'change_password_password_hint'),
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
                                controller: _newPasswordConfirmController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return AppLocalizations.of(context)
                                        .translate(
                                            'change_password_password_hint');
                                  } else if (value.length >= 7) {
                                    if (_newPasswordController.text !=
                                        _newPasswordConfirmController.text) {
                                      return AppLocalizations.of(context)
                                          .translate(
                                              'set_password_password_mismatch');
                                    } else
                                      return null;
                                  } else
                                    return AppLocalizations.of(context)
                                        .translate(
                                            'set_password_password_short');
                                },
                                decoration: InputDecoration(
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  labelText: AppLocalizations.of(context).translate(
                                      'change_password_confirm_password_label'),
                                  hintStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  hintText: AppLocalizations.of(context).translate(
                                      'change_password_confirm_password_hint'),
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.tealAccent,
          onPressed: () async {
            print(_formKey.currentState.validate());
            if (_formKey.currentState.validate()) {
              Nonce nonce = await KeyManager().getPasswordNonce();
              Uint8List oldListPassword = await Cryption()
                  .passwordHash(_oldPasswordController.text.toString(), nonce);
              String oldHexPassword = hex.encode(oldListPassword);
              String oldStoredPassword = await KeyManager().getHexPassword();
              print('oldHexPassword: $oldHexPassword');
              print('oldStoredPassword: $oldStoredPassword');
              if (oldHexPassword == oldStoredPassword) {
                Uint8List newPassword = await Cryption()
                    .passwordHash(_newPasswordController.text.toString(), null);
                String newHexPassword = hex.encode(newPassword);
                KeyManager().changePassword(newHexPassword);
                bool test = await TCP().changePassword(oldHexPassword);
                if (test) {
                  Navigator.of(context).pop(MaterialPageRoute(
                      builder: (BuildContext context) => PasswordChange()));
                } else {
                  print('test not true');
                  return Scaffold.of(context)
                      .showSnackBar(_snackBar('first_start_snackbar_message'));
                }
              } else {
                print('old and new Password !=');
                return Scaffold.of(context)
                    .showSnackBar(_snackBar('first_start_snackbar_message'));
              }
            } else {
              print('not valid?!');
              return Scaffold.of(context)
                  .showSnackBar(_snackBar('first_start_snackbar_message'));
            }
          },
          child: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
