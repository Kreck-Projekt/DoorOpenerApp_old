// TODO: Prompt if user want to use entered Code now or later
// TODO: Prompt if user want to use entered QR Code now or later
// TODO: Save OTPData in SharedPrefs as JSON

import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/constants.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/otp_ticket.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/models/otp.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';

class SavedQRCodesScreen extends StatefulWidget {
  @override
  _SavedQRCodesScreenState createState() => _SavedQRCodesScreenState();
}

class _SavedQRCodesScreenState extends State<SavedQRCodesScreen> {

  List<OTP> otpModel = [];

  void delete(String otp) {
    print(otpModel.length);
    print(otpModel.isEmpty);
    otpModel.removeWhere((otpObject) => otpObject.otp == otp);
    DataManager.saveAllOTP(otpModel);
    setState(() {
      print(otpModel.length);
      print(otpModel.isEmpty);
    });
  }

  void init() async {
    await DataManager.saveAllOTP([OTP(otp: "awrscsdfsfas", ip: "187.165.145.54", port: 5000)]);
    otpModel = await DataManager.storedOTP;
  }

  @override
  void initState() {
    init();
    super.initState();
  }

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
                          .translate(otpModel.isNotEmpty ? "saved_qr_codes_screen_explanation" : "saved_qr_codes_screen_empty"),
                    ),
                    SizedBox(height: 10),
                    otpModel.isNotEmpty ? OtpTicket(otpModel[0],delete) : Container(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
