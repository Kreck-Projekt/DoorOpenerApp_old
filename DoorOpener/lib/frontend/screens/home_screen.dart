import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/otp_open_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/android_appbar.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/bottomButton.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/innerWidget.dart'
    as inside;
import 'package:raspberry_pi_door_opener/frontend/widgets/snackbar.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../constants.dart';

const TWO_PI = 3.14 * 2;

class Homescreen extends StatefulWidget {
  static const routeName = '/homescreen';

  Homescreen({Key key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final size = 200.0;
  int initValue = 5000;
  GlobalKey _key = new GlobalKey();
  DataManager data = DataManager();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    var tempValue = await data.time ?? 2;
    print('tempValue: $tempValue');
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Container(
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
                        animationEnabled: true,
                        angleRange: 360.0,
                        startAngle: 90,
                      ),
                      min: 0,
                      initialValue: initValue.toDouble() / 1000,
                      max: 10,
                      onChangeEnd: (value) {
                        DataManager().safeTime(((value).ceil()) * 1000);
                      },
                      innerWidget: (value) {
                        return Container(
                          child: inside.InnerWidget(value),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Builder(
                      builder: (BuildContext ctx) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              bottomButton('home_screen_generate_otp', () async {
                                if (!(await DataManager().handleOTP(context))) {
                                  return snackBar(
                                      'first_start_snackbar_message', ctx);
                                }
                              }, context),
                              bottomButton('home_screen_enter_otp', () {
                                return Navigator.of(context)
                                    .pushNamed(OtpOpenScreen.routeName);
                              }, context)
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
