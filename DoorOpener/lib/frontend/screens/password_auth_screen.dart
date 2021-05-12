import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/snackbar.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/other/inputDecorationHandler.dart';
import 'package:raspberry_pi_door_opener/utils/security/auth_handler.dart';

import '../constants.dart';

class PasswordAuth extends StatefulWidget {
  static const routeName = '/password-auth';

  @override
  _PasswordAuthState createState() => _PasswordAuthState();
}

class _PasswordAuthState extends State<PasswordAuth> {
  String hint;
  String explanation;
  String label;
  var route;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool initData = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (initData) {
      Map<String, dynamic> tempData =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      hint = tempData['hint'];
      explanation = tempData['explanation'];
      label = tempData['label'];
      route = tempData['route'];
      initData = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          child: Container(
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
                                .translate(explanation),
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal),
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
                                  keyboardType: TextInputType.number,
                                  obscureText: true,

                                  style:
                                      Theme.of(context).textTheme.bodyText1,
                                  controller: _passwordController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return AppLocalizations.of(context)
                                          .translate(hint);
                                    }
                                    return null;
                                  },
                                  decoration: inputDecorationHandler(
                                      context, label, hint),
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
      ),
      floatingActionButton: Builder(
        builder: (BuildContext ctx) {
          return FloatingActionButton(
            backgroundColor: kDarkDefaultColor,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                String password = _passwordController.text.toString();
                AuthHandler().passwordAuth(password, route, ctx);
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
