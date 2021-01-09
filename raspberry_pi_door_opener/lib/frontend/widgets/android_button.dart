import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';

Widget androidButton(context) {
  return Center(
    child: InkWell(
        child: Container(
          height: 50,
          width: 270,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(0.0, 20.0),
                  blurRadius: 30.0,
                  color: Colors.black12)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.0),
          ),
          child: Row(children: [
            Container(
              height: 50.0,
              width: 220.0,
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: Text(
                AppLocalizations.of(context).translate('android_button_open'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1.copyWith(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(95.0),
                  topLeft: Radius.circular(95.0),
                  bottomRight: Radius.circular(235),
                ),
              ),
            ),
            Icon(
              Icons.vpn_key_outlined,
              size: 30,
              color: Colors.teal,
            ),
          ]),
        ),
        onTap: () {}),
  );
}
