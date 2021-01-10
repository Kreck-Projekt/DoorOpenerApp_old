import 'package:cryptography/cryptography.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/homescreen.dart';
import 'package:raspberry_pi_door_opener/utils/cryptography/cryption.dart';
import 'package:raspberry_pi_door_opener/utils/cryptography/key_manager.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';


class PasswordAuth extends StatefulWidget {
  PasswordAuth({Key key}) : super(key: key);

  @override
  _PasswordAuthState createState() => _PasswordAuthState();
}

class _PasswordAuthState extends State<PasswordAuth> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

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
        body: Container(
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
                            .translate('password_auth_explanation'),
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
                              controller: _passwordController,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return AppLocalizations.of(context)
                                      .translate(
                                      'password_auth_password_hint');
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelStyle:
                                Theme.of(context).textTheme.bodyText1,
                                labelText: AppLocalizations.of(context)
                                    .translate(
                                    'password_auth_password_label'),
                                hintStyle:
                                Theme.of(context).textTheme.bodyText1,
                                hintText: AppLocalizations.of(context)
                                    .translate(
                                    'password_auth_password_hint'),
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
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.tealAccent,
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              String password = _passwordController.text.toString();
              final Nonce nonce = await KeyManager().getPasswordNonce();
              String hashedPassword = hex.encode(await Cryption().passwordHash(password, nonce));
              String hexPassword = await KeyManager().getHexPassword();
              if (hashedPassword == hexPassword) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => Homescreen()));
              }  else return ScaffoldMessenger.of(context)
                  .showSnackBar(_snackBar('first_start_snackbar_message'));
            }  else return ScaffoldMessenger.of(context)
                .showSnackBar(_snackBar('first_start_snackbar_message'));
          },
          child: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}