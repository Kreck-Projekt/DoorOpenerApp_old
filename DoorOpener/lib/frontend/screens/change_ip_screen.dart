import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';

class ChangeIP extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
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
                          .translate('change_ip_explanation'),
                      style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: 20, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
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
                              style: Theme.of(context).textTheme.bodyText1,
                              controller: ipController,
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
          onPressed: () {
            DataManager().ipReset(ipController.text.toString());
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
