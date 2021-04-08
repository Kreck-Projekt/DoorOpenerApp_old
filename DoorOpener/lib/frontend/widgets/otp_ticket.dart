import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/models/otp.dart';
import 'package:screenshot/screenshot.dart';
import 'package:ticketview/ticketview.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../constants.dart';

class OtpTicket extends StatefulWidget {
  final OTP otpModel;

  OtpTicket(this.otpModel);

  @override
  _OtpTicketState createState() => _OtpTicketState();
}

class _OtpTicketState extends State<OtpTicket>
    with SingleTickerProviderStateMixin {
  bool small = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Slidable(
      actionPane: SlidableStrechActionPane(),
      child: small
          ? _ticketViewSmall(size, context, widget.otpModel.otp)
          : OtpTicketExpanded(otp: widget.otpModel),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: small ? 'More' : 'Less',
          color: Colors.black45,
          icon: Icons.more_horiz,
          onTap: () => {
            setState(
              () {
                small = !small;
              },
            ),
          },
        ),
        IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () => print('Share'),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => print('Delete'),
        ),
      ],
    );
  }
}

Widget _ticketViewSmall(Size size, BuildContext context, String otp) {
  return TicketView(
    drawShadow: true,
    drawBorder: true,
    contentBackgroundColor: kDarkTicketColor,
    backgroundPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
    backgroundColor: Colors.transparent,
    borderRadius: 6,
    drawDivider: true,
    // trianglePos: .5,
    child: Container(
      height: size.height * .155,
      width: size.width * .835,
      child: Row(
        children: [
          Container(
            width: size.width * .53,
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)
                        .translate("saved_qr_codes_screen_otp"),
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontSize: size.width * .05),
                  ),
                  SizedBox(height: kDefaultPadding),
                  Text(otp, style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            ),
          ),
          SizedBox(width: size.width * 0.055),
          InkWell(
            enableFeedback: false,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {},
            child: Container(
              height: size.height * .33,
              width: size.width * .25,
              child: Center(
                child: Icon(
                  Icons.vpn_key_outlined,
                  size: 40,
                  color: kDarkDefaultColor,
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

class OtpTicketExpanded extends StatefulWidget {
  final OTP otp;

  const OtpTicketExpanded({Key key, this.otp}) : super(key: key);

  @override
  _OtpTicketExpandedState createState() => _OtpTicketExpandedState();
}

class _OtpTicketExpandedState extends State<OtpTicketExpanded>
    with TickerProviderStateMixin {
  ScreenshotController screenshot = ScreenshotController();
  bool view = true;
  int indexStore;
  Tween trianglePos = Tween(begin: .32, end: .32);
  String payload;

  @override
  void initState() {
    super.initState();
    payload = "o:${widget.otp.otp};${widget.otp.ip};${widget.otp.port}";
  }

  void _changeData(int index) async {
    setState(() {
      if (index == 0) {
        view = true;
      } else {
        view = false;
      }
      indexStore = index;
    });
    switchTriangle();
  }

  void switchTriangle() {
    setState(() {
      if (view) {
        trianglePos = Tween(begin: .39, end: .32);
      } else {
        trianglePos = Tween(begin: .32, end: .39);
        print("changed");
      }
      print(trianglePos.toString());
    });
  }

  Widget _text(BuildContext context, Size size) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "OTP:",
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 15),
                ),
                SizedBox(width: size.width * .025),
                Text(
                  "${widget.otp.otp}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            SizedBox(height: size.height * .025),
            Row(
              children: [
                Text(
                  "Ip Adress:",
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 15),
                ),
                SizedBox(width: size.width * .025),
                Text(
                  "${widget.otp.ip}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            SizedBox(height: size.height * .025),
            Row(
              children: [
                Text(
                  "Port:",
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 15),
                ),
                SizedBox(width: size.width * .025),
                Text(
                  "${widget.otp.port}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            SizedBox(height: size.height * .025),
          ],
        ),
      ),
    );
  }

  Widget _qr(Size size) {
    return Center(
      child: Container(
        color: Colors.white,
        height: size.height * .2175,
        width: size.width * .475,
        child: Screenshot(
          controller: screenshot,
          child: QrImage(
            data: payload,
            version: QrVersions.auto,
            size: 200,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TweenAnimationBuilder(
      tween: trianglePos,
      duration: Duration(milliseconds: 300),
      builder: (BuildContext context, value, child) {
        return TicketView(
          drawShadow: true,
          drawBorder: true,
          contentBackgroundColor: kDarkTicketColor,
          backgroundPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 0),
          drawArc: false,
          triangleAxis: Axis.vertical,
          borderRadius: 6,
          drawDivider: true,
          trianglePos: value,
          child: AnimatedSize(
            reverseDuration: Duration(milliseconds: 300),
            duration: Duration(milliseconds: 300),
            vsync: this,
            child: Container(
              height: view ? size.height * .50 : size.height * .41,
              width: size.width * .835,
              child: Container(
                width: size.width * .53,
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)
                              .translate("saved_qr_codes_screen_otp"),
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(fontSize: size.width * .05),
                        ),
                        SizedBox(height: kDefaultPadding),
                        Text(
                          widget.otp.otp,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(height: size.height * .093),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: kDarkDefaultColor.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(
                                    0,
                                    7,
                                  ), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ToggleSwitch(
                              inactiveBgColor:
                                  kDarkBackgroundColor.withOpacity(1),
                              minWidth: size.width * .275,
                              initialLabelIndex: indexStore ?? 0,
                              labels: ['QR-Code', 'Text'],
                              onToggle: (index) {
                                _changeData(index);
                                print('payload: $payload');
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * .025),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          switchInCurve: Curves.easeInCirc,
                          switchOutCurve: Curves.easeInCirc,
                          reverseDuration: Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) =>
                                  ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                          child: view
                              ? _qr(
                                  size,
                                )
                              : _text(
                                  context,
                                  size,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
