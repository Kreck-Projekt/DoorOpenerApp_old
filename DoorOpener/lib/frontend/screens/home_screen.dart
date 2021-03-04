import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/android_appbar.dart';
import 'package:raspberry_pi_door_opener/frontend/widgets/snackbar.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';
import 'package:raspberry_pi_door_opener/utils/tcp/tcp_connection.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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
  Color keyColor = Colors.red;
  IconData sliderIcon = Icons.keyboard_arrow_up_rounded;
  GlobalKey _key = new GlobalKey();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    var tempValue = await DataManager().getTime() ?? 2;
    print('tempValue: $tempValue');
    setState(() {
      initValue = tempValue;
    });
  }

  void _pressed(int time) async {
    TCP().openDoor(time);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      keyColor = Colors.green;
    });
    await Future.delayed(Duration(milliseconds: time));
    setState(() {
      keyColor = Colors.red;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: androidAppBar(context),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: size + 10,
                  height: size + 10,
                  child: SleekCircularSlider(
                    key: _key,
                    appearance: CircularSliderAppearance(
                      customColors: CustomSliderColors(
                        progressBarColor: Colors.teal,
                        dotColor: Colors.white,
                        dynamicGradient: true,
                        trackColor: Colors.teal,
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
                      return Center(
                        child: InkWell(
                          child: Container(
                            width: size,
                            height: size,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    width: size - 40,
                                    height: size - 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.vpn_key_outlined,
                                            color: keyColor,
                                            size: 40,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '${value.ceil()}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1
                                                .copyWith(
                                                  fontSize: 40,
                                                  fontWeight:
                                                      FontWeight.normal,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            _pressed((value.ceil()) * 1000);
                          },
                          onLongPress: () {
                            _pressed((value.ceil()) * 1000);
                          },
                        ),
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
                      return InkWell(
                        child: SizedBox(
                          height: 80,
                          width: double.infinity,
                          child: Card(
                            borderOnForeground: true,
                            elevation: 7,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('home_screen_generate_otp'),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          if (!await DataManager().handleOTP(context)) {
                            return Scaffold.of(ctx).showSnackBar(
                              snackBar('first_start_snackbar_message', ctx),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
