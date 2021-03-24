import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/constants.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';

Widget bottomButton(String text, Function function, BuildContext context) {
  return Container(
    color: kDarkDefaultColor,
    width: MediaQuery.of(context).size.width * .49,
    child: InkWell(
      child: SizedBox(
        height: 80,
        // width: double.infinity,
        child: Card(
          borderOnForeground: true,
          elevation: 7,
          child: Center(
            child: Text(
              AppLocalizations.of(context).translate(text),
              style:
                  Theme.of(context).textTheme.headline1.copyWith(fontSize: 20),
              softWrap: true,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      onTap: () async {
        await function();
      },
    ),
  );
}
