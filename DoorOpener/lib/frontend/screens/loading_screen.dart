// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/home_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/password_set_screen.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';
import 'package:raspberry_pi_door_opener/utils/security/key_manager.dart';
import 'package:raspberry_pi_door_opener/utils/tcp/tcp_connection.dart';

import '../constants.dart';

class LoadingScreen extends StatefulWidget {
  static const routeName = '/loading-screen';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

const twoPi = 3.14 * 2;

class _LoadingScreenState extends State<LoadingScreen> {
  double end = 0.01;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final bool key = await TCP().sendKey(context);
    if (key) {
      setState(() {
        end = .33;
      });
      await Future.delayed(const Duration(seconds: 2));
      final bool password = await TCP().sendPassword(context);
      if (password) {
        setState(() {
          end = .66;
        });
        await Future.delayed(const Duration(seconds: 2));
        final bool nonce = await TCP().sendNonce(context);
        if (nonce) {
          setState(() {
            end = 1.0;
          });
          await Future.delayed(const Duration(seconds: 2));
          Navigator.of(context).pushReplacementNamed(Homescreen.routeName);
        } else {
          DataManager.appReset(context);
          Navigator.of(context).pushReplacementNamed(SetPassword.routeName);
        }
      } else {
        DataManager.appReset(context);
        Navigator.of(context).pushReplacementNamed(SetPassword.routeName);
      }
    } else {
      DataManager.appReset(context);
      Navigator.of(context).pushReplacementNamed(SetPassword.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    const size = 200.0;
    return Scaffold(
      backgroundColor: kDarkBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: TweenAnimationBuilder(
                  duration: const Duration(seconds: 2),
                  tween: Tween(begin: 0.0, end: end),
                  builder: (context, value, child) {
                    final int percentage = (value * 100).ceil() as int;
                    return SizedBox(
                      width: size,
                      height: size,
                      child: Stack(
                        children: <Widget>[
                          ShaderMask(
                            shaderCallback: (rect) {
                              return SweepGradient(
                                endAngle: twoPi,
                                stops: [value as double, value as double],
                                colors: [kDarkDefaultColor, Colors.grey.withAlpha(55)],
                              ).createShader(rect);
                            },
                            child: Container(
                              height: size,
                              width: size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: Image.asset("assets/images/radial_scale.png").image,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: size - 40,
                              height: size - 40,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
                              child: Center(
                                child: Text(
                                  "$percentage %",
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                                        fontSize: 40,
                                        color: Colors.white.withOpacity(.55),
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(kDarkDefaultColor),
                  ),
                  onPressed: () {
                    KeyManager().reset();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) => SetPassword(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white.withOpacity(.55),
                  ),
                  label: Text(
                    AppLocalizations.of(context).translate('loading_screen_start_again'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
