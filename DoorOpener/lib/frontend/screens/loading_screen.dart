import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/home_screen.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/password_set_screen.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/security/key_manager.dart';
import 'package:raspberry_pi_door_opener/utils/tcp/tcp_connection.dart';

class LoadingScreen extends StatefulWidget {
  static const routeName = '/loading-screen';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

const TWO_PI = 3.14 * 2;

class _LoadingScreenState extends State<LoadingScreen> {
  var end = 0.01;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    bool key = await TCP().sendKey();
    if (key) {
      setState(() {
        end = 0.33;
      });
      await Future.delayed(Duration(seconds: 2));
      bool password = await TCP().sendPassword();
      if (password) {
        setState(() {
          end = 1.0;
        });
        await Future.delayed(Duration(seconds: 2));
        Navigator.of(context).pushReplacementNamed(Homescreen.routeName);
      } else {
        KeyManager().reset();
        Navigator.of(context).pushReplacementNamed(SetPassword.routeName);
      }
    } else {
      KeyManager().reset();
      Navigator.of(context).pushReplacementNamed(SetPassword.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = 200.0;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TweenAnimationBuilder(
                duration: Duration(seconds: 2),
                tween: Tween(begin: 0.0, end: end),
                builder: (context, value, child) {
                  int percentage = (value * 100).ceil();
                  return Container(
                    width: size,
                    height: size,
                    child: Stack(
                      children: <Widget>[
                        ShaderMask(
                          shaderCallback: (rect) {
                            return SweepGradient(
                                startAngle: 0.0,
                                endAngle: TWO_PI,
                                center: Alignment.center,
                                stops: [
                                  value,
                                  value
                                ],
                                colors: [
                                  Colors.blue,
                                  Colors.grey.withAlpha(55)
                                ]).createShader(rect);
                          },
                          child: Container(
                            height: size,
                            width: size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: Image.asset(
                                        "assets/images/radial_scale.png")
                                    .image,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: size - 40,
                            height: size - 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent),
                            child: Center(
                              child: Text(
                                "$percentage %",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 40),
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
              child: RaisedButton.icon(
                onPressed: () {
                  KeyManager().reset();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => SetPassword()));
                },
                icon: Icon(Icons.arrow_back),
                label: Text(AppLocalizations.of(context)
                    .translate('loading_screen_start_again')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
