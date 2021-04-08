// TODO: Add SavedQRCodesScreen
// TODO: Add AddQRCodesScreen
// TODO: Prompt if user want to use entered Code now or later
// TODO: Prompt if user want to use entered QR Code now or later
// TODO: Rename OTP open to OTP add
// TODO: Save OTPData in SharedPrefs as JSON
// TODO: Prompt by clicking on a OTP if user want to use it now or want to see the information or delete it.

import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/constants.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/otp_ticket.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/models/otp.dart';

class SavedQRCodesScreen extends StatefulWidget {
  @override
  _SavedQRCodesScreenState createState() => _SavedQRCodesScreenState();
}

class _SavedQRCodesScreenState extends State<SavedQRCodesScreen> {

  OTP otpModel = OTP(otp: "dasweafasdad", ip: "192.168.178.15", port: 5000);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)
              .translate("saved_qr_codes_screen_title")),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(kDefaultPadding / 2),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      AppLocalizations.of(context)
                          .translate("saved_qr_codes_screen_explanation"),
                    ),
                    SizedBox(height: 10),
                    OtpTicket(otpModel),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
