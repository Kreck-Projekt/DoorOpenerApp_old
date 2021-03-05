import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/snackbar.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';

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
      appBar: AppBar(title: Text('OTP Open'),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Text(AppLocalizations.of(context).translate('otp_screen_explain'),
                ),
                SizedBox(height:10),
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
                          controller: _otpController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate(
                                  'otp_screen_otp_hint');
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelStyle:
                            Theme.of(context).textTheme.bodyText1,
                            labelText: AppLocalizations.of(context)
                                .translate(
                                'otp_screen_otp_label'),
                            hintStyle:
                            Theme.of(context).textTheme.bodyText1,
                            hintText: AppLocalizations.of(context)
                                .translate(
                                'otp_screen_otp_hint'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        SizedBox(height: 30,),
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
                          decoration: InputDecoration(
                            labelStyle:
                            Theme.of(context).textTheme.bodyText1,
                            labelText: AppLocalizations.of(context)
                                .translate('first_start_ip_label'),
                            hintStyle:
                            Theme.of(context).textTheme.bodyText1,
                            hintText: AppLocalizations.of(context)
                                .translate('first_start_ip_hint'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
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
                          decoration: InputDecoration(
                            labelStyle:
                            Theme.of(context).textTheme.bodyText1,
                            labelText: AppLocalizations.of(context)
                                .translate('first_start_port_label'),
                            hintStyle:
                            Theme.of(context).textTheme.bodyText1,
                            hintText: AppLocalizations.of(context)
                                .translate('first_start_port_hint'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
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
                          decoration: InputDecoration(
                            labelStyle:
                            Theme.of(context).textTheme.bodyText1,
                            labelText: AppLocalizations.of(context)
                                .translate('first_start_open_label'),
                            hintStyle:
                            Theme.of(context).textTheme.bodyText1,
                            hintText: AppLocalizations.of(context)
                                .translate('first_start_open_hint'),
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
        ),
      ),
      // TODO: Add new Method
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.tealAccent,
        onPressed: () async{
          if (_formKey.currentState.validate()) {
            // String ipAddress = ipController.text.toString();
            // int port = int.parse(portController.text.toString());
            // int time = int.parse(openController.text.toString());
          }else return snackBar('first_start_snackbar_message', context);
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
