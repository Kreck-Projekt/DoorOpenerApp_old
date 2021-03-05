import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/snackbar.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';
import 'package:raspberry_pi_door_opener/utils/security/auth_handler.dart';
import 'package:raspberry_pi_door_opener/utils/security/biometric_handler.dart';

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
      Map<String, dynamic> tempData = ModalRoute.of(context).settings.arguments as Map<String,dynamic>;
      hint = tempData['hint'];
      explanation = tempData['explanation'];
      label = tempData['label'];
      route = tempData['route'];
      initData  = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
  }

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
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    bool localAuthEnabled = await DataManager().getLocalAuth();
    if(localAuthEnabled) {
      BiometricHandler().authenticate(AppLocalizations.of(context).translate('password_auth_local'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
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
                          AppLocalizations.of(context).translate(explanation),
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
                                        .translate(hint);
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  labelText: AppLocalizations.of(context)
                                      .translate(label),
                                  hintStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  hintText: AppLocalizations.of(context)
                                      .translate(hint),
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
      ),
      floatingActionButton: Builder(
        builder: (BuildContext ctx) {
          return FloatingActionButton(
            backgroundColor: Colors.tealAccent,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                String password = _passwordController.text.toString();
                AuthHandler().passwordAuth(password, route, ctx);
              } else
                return snackBar( 'first_start_snackbar_message', ctx);
            },
            child: Icon(Icons.arrow_forward),
          );
        },
      ),
    );
  }
}
