

import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';

class Credits extends StatelessWidget {
  static const routeName = '/credits';

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final text = AppLocalizations.of(context);

    Widget spacing() {
      return Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey.shade300,
      );
    }

    Widget name(String name) {
      return ListTile(
        title: Text(
          name,
          style: textStyle.headline1.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.left,
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            text.translate('credits_screen_title'),
            style: textStyle.headline1
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Card(
              elevation: 5,
              margin: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.accessibility_new_outlined),
                    title: Text(
                      text.translate('credits_screen_developer'),
                      style: textStyle.headline1.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  spacing(),
                  name('NikoMitK'),
                  spacing(),
                  name('jxstxn1'),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.language_outlined),
                    title: Text(
                      text.translate('credits_screen_translations'),
                      style: textStyle.headline1.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  spacing(),
                  name('Arabic by 5HR3D'),
                  spacing(),
                  name('German by jxstxn1'),
                  spacing(),
                  name(
                    'English by jxstxn1',
                  ),
                  spacing(),
                  name('Espanol by Edgar Manuelsen'),
                  spacing(),
                  name('Hindi by 5HR3D'),
                  spacing(),
                  name('Indonesian by 5HR3D'),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.add_box_outlined),
                    title: Text(
                      text.translate('credits_screen_packages'),
                      style: textStyle.headline1.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  spacing(),
                  name('cryptography'),
                  spacing(),
                  name('tcp_socket_connection'),
                  spacing(),
                  name(
                    'shared_preferences',
                  ),
                  spacing(),
                  name('flutter_secure_storage'),
                  spacing(),
                  name('sleek_circular_slider'),
                  spacing(),
                  name('qr_flutter'),
                  spacing(),
                  name('flutter_barcode_scanner'),
                  spacing(),
                  name('introduction_screen'),
                  spacing(),
                  name('local_auth'),
                  spacing(),
                  name('string_validator'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
