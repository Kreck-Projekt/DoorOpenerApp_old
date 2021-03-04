import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

// TODO: Complete Onboarding Screen
class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding-screen';

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: IntroductionScreen(
          pages: [
            PageViewModel(
              titleWidget: Text(
                'Welcome',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              bodyWidget: Text(
                'We guide you through all the necessary steps to get your device running and explain everything to  you',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          onDone: () {},
          done: Text('Done'),
        ));
  }
}
