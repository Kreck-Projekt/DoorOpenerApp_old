import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:raspberry_pi_door_opener/frontend/screens/share_credentials_screen.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/models/otp.dart';
import 'package:raspberry_pi_door_opener/utils/tcp/tcp_connection.dart';
import 'package:screenshot/screenshot.dart';
import 'package:ticketview/ticketview.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../constants.dart';

class OtpTicket extends StatefulWidget {
  final OTP otpModel;
  final Function delete;

  const OtpTicket(this.otpModel, this.delete);

  @override
  _OtpTicketState createState() => _OtpTicketState();
}

class _OtpTicketState extends State<OtpTicket> with SingleTickerProviderStateMixin {
  bool small = true;
  String payload;
  ScreenshotController screenshot = ScreenshotController();

  @override
  void initState() {
    super.initState();
    payload = "o:${widget.otpModel.otp};${widget.otpModel.ip};${widget.otpModel.port}";
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Slidable(
      actionPane: const SlidableStrechActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: AppLocalizations.of(context)
              .translate(small ? "saved_qr_codes_screen_more" : "saved_qr_codes_screen_less"),
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
          caption: AppLocalizations.of(context).translate("saved_qr_codes_screen_share"),
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () {
            Navigator.of(context).pushNamed(
              ShareCredentials.routeName,
              arguments: [widget.otpModel],
            );
          },
        ),
        IconSlideAction(
          caption: AppLocalizations.of(context).translate("saved_qr_codes_screen_delete"),
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  AppLocalizations.of(context).translate("saved_qr_codes_screen_delete_title"),
                  style: Theme.of(context).textTheme.headline1,
                ),
                content: Text(
                  AppLocalizations.of(context).translate("saved_qr_codes_screen_delete_text"),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                actions: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kDarkDefaultColor,
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context).translate("saved_qr_codes_screen_keep"),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: size.width * .035,
                              color: Colors.white.withOpacity(.87),
                            ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      widget.delete(widget.otpModel.otp);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Text(
                        AppLocalizations.of(context).translate("saved_qr_codes_screen_delete"),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: size.width * .035,
                              color: Colors.white.withOpacity(.87),
                            ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
      child: small
          ? _ticketViewSmall(size, context, widget.otpModel, widget.delete)
          : OtpTicketExpanded(otp: widget.otpModel),
    );
  }
}

Widget _ticketViewSmall(Size size, BuildContext context, OTP otpModel, Function delete) {
  return TicketView(
    contentBackgroundColor: kDarkTicketColor,
    backgroundPadding: const EdgeInsets.symmetric(horizontal: 20),
    backgroundColor: Colors.transparent,
    borderRadius: 6,
    // trianglePos: .5,
    child: SizedBox(
      height: size.height * .155,
      width: size.width * .835,
      child: Row(
        children: [
          SizedBox(
            width: size.width * .53,
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate("saved_qr_codes_screen_otp"),
                    style: Theme.of(context).textTheme.headline1.copyWith(fontSize: size.width * .05),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  Text(otpModel.otp, style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            ),
          ),
          SizedBox(width: size.width * 0.055),
          InkWell(
            enableFeedback: false,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              debugPrint("Open");
              TCP().otpOpen(otpModel.otp, 2000, otpModel.ip, otpModel.port, context);
              delete(otpModel.otp);
            },
            child: SizedBox(
              height: size.height * .33,
              width: size.width * .25,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.vpn_key_outlined,
                      size: 40,
                      color: kDarkDefaultColor,
                    ),
                    SizedBox(height: size.height * .012),
                    Text(
                      AppLocalizations.of(context).translate("saved_qr_codes_screen_open"),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
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

class _OtpTicketExpandedState extends State<OtpTicketExpanded> with TickerProviderStateMixin {
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

  Future<void> _changeData(int index) async {
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
        debugPrint("changed");
      }
      debugPrint(trianglePos.toString());
    });
  }

  Widget _text(BuildContext context, Size size) {
    return Center(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "OTP:",
                style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 15),
              ),
              SizedBox(width: size.width * .025),
              Text(
                widget.otp.otp,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          SizedBox(height: size.height * .025),
          Row(
            children: [
              Text(
                "Ip Adress:",
                style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 15),
              ),
              SizedBox(width: size.width * .025),
              Text(
                widget.otp.ip,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          SizedBox(height: size.height * .025),
          Row(
            children: [
              Text(
                "Port:",
                style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 15),
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
            size: 200,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return TweenAnimationBuilder(
      tween: trianglePos,
      duration: const Duration(milliseconds: 300),
      builder: (BuildContext context, value, child) {
        return TicketView(
          contentBackgroundColor: kDarkTicketColor,
          backgroundColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(vertical: 24),
          triangleAxis: Axis.vertical,
          borderRadius: 6,
          trianglePos: value as double,
          child: AnimatedSize(
            reverseDuration: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 300),
            child: SizedBox(
              height: view ? size.height * .50 : size.height * .41,
              width: size.width * .835,
              child: SizedBox(
                width: size.width * .53,
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).translate("saved_qr_codes_screen_otp"),
                              style: Theme.of(context).textTheme.headline1.copyWith(fontSize: size.width * .05),
                            ),
                            const SizedBox(height: kDefaultPadding),
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
                                      offset: const Offset(
                                        0,
                                        7,
                                      ), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: ToggleSwitch(
                                  inactiveBgColor: kDarkBackgroundColor.withOpacity(1),
                                  minWidth: size.width * .275,
                                  initialLabelIndex: indexStore ?? 0,
                                  labels: const ['QR-Code', 'Text'],
                                  onToggle: (index) {
                                    _changeData(index);
                                    debugPrint('payload: $payload');
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * .025),
                            Expanded(
                              child: Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 300),
                                        switchInCurve: Curves.easeInCirc,
                                        switchOutCurve: Curves.easeInCirc,
                                        reverseDuration: const Duration(milliseconds: 300),
                                        transitionBuilder: (Widget child, Animation<double> animation) =>
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
