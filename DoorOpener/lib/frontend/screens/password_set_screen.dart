import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/constants.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/otp_add_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/second_device_init_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/snackbar.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/other/inputDecorationHandler.dart';
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
        backgroundColor: kDarkBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              child: Column(
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
                                color: Colors.white.withOpacity(.87),
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
                            style:
                                Theme.of(context).textTheme.headline1.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white.withOpacity(.57),
                                    ),
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
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Colors.white.withOpacity(.55),
                                      ),
                                  controller: _password1Controller,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return AppLocalizations.of(context)
                                          .translate(
                                              'set_password_password_hint');
                                    } else if (value.length <= 7) {
                                      return AppLocalizations.of(context)
                                          .translate(
                                              'set_password_password_hint');
                                    } else
                                      return null;
                                  },
                                  cursorColor: kDarkDefaultColor,
                                  decoration: inputDecorationHandler(
                                    context,
                                    'set_password_password_label',
                                    'set_password_password_hint',
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  style: Theme.of(context).textTheme.bodyText1,
                                  controller: _password2Controller,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return AppLocalizations.of(context)
                                          .translate(
                                              'set_password_password_hint');
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
                                          .translate(
                                              'set_password_password_short');
                                  },
                                  cursorColor: kDarkDefaultColor,
                                  decoration: inputDecorationHandler(
                                    context,
                                    'set_password_confirm_password_label',
                                    'set_password_confirm_password_hint',
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
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Colors.white.withOpacity(.55)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        SecondDeviceInit.routeName,
                      );
                    },
                    child: Icon(
                      Icons.qr_code,
                      size: 40,
                      color: Colors.white.withOpacity(.87),
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    AppLocalizations.of(context).translate('set_password_otp'),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Colors.white.withOpacity(.55),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        OtpOpenScreen.routeName,
                      );
                    },
                    child: Icon(
                      Icons.adjust,
                      size: 40,
                      color: Colors.white.withOpacity(.87),
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
                  String password = _password2Controller.text.toString();
                  await AuthHandler().setPassword(password, ctx);
                } else
                  return snackBar('first_start_snackbar_message', ctx);
              },
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white.withOpacity(.87),
              ),
            );
          },
        ));
  }
}
