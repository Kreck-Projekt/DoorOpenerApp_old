import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/otp_add_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/android_appbar.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/bottom_button.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/inner_widget.dart'
    as inside;
import 'package:raspberry_pi_door_opener/frontend/widgets/snackbar.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../constants.dart';

const twoPi = 3.14 * 2;

class Homescreen extends StatefulWidget {
  static const routeName = '/homescreen';

  const Homescreen({Key key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final size = 200.0;
  int initValue = 5000;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final tempValue = await DataManager.time ?? 2;
    debugPrint('tempValue: $tempValue');
    setState(() {
      initValue = tempValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackgroundColor,
      appBar: androidAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: size + 30,
                    height: size + 30,
                    child: SleekCircularSlider(
                      key: _key,
                      appearance: CircularSliderAppearance(
                        customColors: CustomSliderColors(
                          progressBarColor: kDarkDefaultColor,
                          dotColor: Colors.white.withOpacity(.55),
                          dynamicGradient: true,
                          trackColor: kDarkDefaultColor,
                          hideShadow: true,
                        ),
                        angleRange: 360.0,
                        startAngle: 90,
                      ),
                      initialValue: initValue.toDouble() / 1000,
                      max: 10,
                      onChangeEnd: (value) {
                        DataManager.safeTime((value.ceil()) * 1000);
                      },
                      innerWidget: (value) {
                        return inside.InnerWidget(value);
                      },
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .035),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Builder(
                    builder: (BuildContext ctx) {
                      return Column(mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          bottomButton(
                            'home_screen_generate_otp',
                            () async {
                              if (!(await DataManager.handleOTP(context))) {
                                return snackBar(
                                  'first_start_snackbar_message',
                                  ctx,
                                );
                              }
                            },
                            context,
                          ),
                          bottomButton(
                            'home_screen_enter_otp',
                            () {
                              return Navigator.of(ctx).pushNamed(
                                OtpOpenScreen.routeName,
                              );
                            },
                            ctx,
                          ),
                        ],
                      );
                    },
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
