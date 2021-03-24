import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/snackbar.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/other/inputDecorationHandler.dart';
import 'package:raspberry_pi_door_opener/utils/security/auth_handler.dart';

import '../constants.dart';

class PasswordChange extends StatefulWidget {
  static const routeName = '/password-change';

  @override
  _PasswordChangeState createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackgroundColor,
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          child: SingleChildScrollView(
            child: Column(
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
                                decoration: inputDecorationHandler(
                                  context,
                                  'change_password_old_password_label',
                                  'change_password_old_password_hint',
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
                                decoration: inputDecorationHandler(
                                    context,
                                    'change_password_password_label',
                                    'change_password_password_hint'),
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
                                decoration: inputDecorationHandler(
                                  context,
                                  'change_password_confirm_password_label',
                                  'change_password_confirm_password_hint',
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
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext ctx) {
          return FloatingActionButton(
            backgroundColor: kDarkDefaultColor,
            onPressed: () async {
              print(_formKey.currentState.validate());
              if (_formKey.currentState.validate()) {
                String _oldPassword = _oldPasswordController.text.toString();
                String _newPassword = _newPasswordController.text.toString();
                await AuthHandler()
                    .changePassword(_oldPassword, _newPassword, ctx);
              } else {
                print('not valid?!');
                return snackBar('first_start_snackbar_message', ctx);
              }
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
