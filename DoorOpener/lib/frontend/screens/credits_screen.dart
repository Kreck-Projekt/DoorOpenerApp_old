

import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';

import '../constants.dart';

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

    Widget name(String name, {String url}) {
      return ListTile(
        leading: url != null ? CircleAvatar(child: Image.network(url, fit: BoxFit.cover,)) : null,
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
        backgroundColor: kDarkBackgroundColor,
        appBar: AppBar(
          title: Text(
            text.translate('credits_screen_title'),
            style: textStyle.headline1
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            child: ListView(
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
                      name(
                          'NikoMitK',
                      url: 'https://avatars.githubusercontent.com/u/68833349?s=460&u=42c8f1bda3cec41fa7b52c80237d414778113f79&v=4',
                      ),
                      spacing(),
                      name(
                        'jxstxn1',
                          url: 'https://avatars.githubusercontent.com/u/29661951?s=460&u=afbf7bcd1d8b53552340d7f0b0b6944bb97c70d9&v=4',
                      ),
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
                      name('Arabic by 5HR3D',
                      url: 'https://d1fdloi71mui9q.cloudfront.net/SFXbsmXFQ4WoalfcdOre_6cF7qzPfQyhAlrXT',
                      ),
                      spacing(),
                      name(
                          'German by jxstxn1',
                          url: 'https://avatars.githubusercontent.com/u/29661951?s=460&u=afbf7bcd1d8b53552340d7f0b0b6944bb97c70d9&v=4',
                      ),
                      spacing(),
                      name(
                        'English by jxstxn1',
                        url: 'https://avatars.githubusercontent.com/u/29661951?s=460&u=afbf7bcd1d8b53552340d7f0b0b6944bb97c70d9&v=4'
                      ),
                      spacing(),
                      name('Espanol by Edgar Manuelsen'),
                      spacing(),
                      name(
                        'Hindi by 5HR3D',
                        url: 'https://d1fdloi71mui9q.cloudfront.net/SFXbsmXFQ4WoalfcdOre_6cF7qzPfQyhAlrXT',
                      ),
                      spacing(),
                      name(
                        'Indonesian by 5HR3D',
                        url: 'https://d1fdloi71mui9q.cloudfront.net/SFXbsmXFQ4WoalfcdOre_6cF7qzPfQyhAlrXT',
                      ),
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
                      spacing(),
                      name('share'),
                      spacing(),
                      name('flutter_phoenix'),
                      spacing(),
                      name('qr_code_tools'),
                      spacing(),
                      name('qr_utils'),
                      spacing(),
                      name('path_provider')
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
