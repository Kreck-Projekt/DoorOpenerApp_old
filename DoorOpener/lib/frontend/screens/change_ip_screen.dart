import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';
import 'package:raspberry_pi_door_opener/utils/other/input_decoration_handler.dart';

import '../constants.dart';

class ChangeIP extends StatelessWidget {
  static const routeName = '/change-ip';

  final _formKey = GlobalKey<FormState>();
  final ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kDarkBackgroundColor,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        AppLocalizations.of(context).translate('change_ip_explanation'),
                        style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      // SizedBox(height: 10,),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 50.0,
                          horizontal: 10.0,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                style: Theme.of(context).textTheme.bodyText1,
                                controller: ipController,
                                keyboardType: TextInputType.number,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (String value) {
                                  //return ipValidator(value, context);
                                  return null;
                                },
                                decoration: inputDecorationHandler(
                                  context,
                                  'first_start_ip_label',
                                  'first_start_ip_hint',
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: kDarkBackgroundColor,
          onPressed: () {
            DataManager.ipReset(
              ipController.text,
            );
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white.withOpacity(.87),
          ),
        ),
      ),
    );
  }
}
