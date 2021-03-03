import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';

class OtpOpenScreen extends StatefulWidget {
  @override
  _OtpOpenScreenState createState() => _OtpOpenScreenState();
}

class _OtpOpenScreenState extends State<OtpOpenScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OTP Open'),),
      body: Container(
        child: Column(
          children: <Widget>[
            Text(AppLocalizations.of(context).translate('otp_screen_explain'),
            ),
            SizedBox(height:10),
            Form(
              key: _formKey,
              child: ,
            )
          ],
        ),
      ),
    );
  }
}
