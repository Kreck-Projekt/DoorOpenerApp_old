import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:raspberry_pi_door_opener/utils/localizations/app_localizations.dart';
import 'package:raspberry_pi_door_opener/utils/other/data_manager.dart';

import '../constants.dart';

class ErrorScreen extends StatefulWidget {
  final int errorCode;

  const ErrorScreen({Key key, this.errorCode}) : super(key: key);

  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  SvgPicture errorImage;
  String errorAsset;
  String errorMessage;
  String title;
  String buttonText;
  Function errorFunction;
  bool init = true;

  @override
  void didChangeDependencies() {
    if (init) {
      final Size size = MediaQuery.of(context).size;
      final local = AppLocalizations.of(context);
      title = local.translate("error_screen_error_title");
      buttonText = local.translate("settings_screen_app_reset");
      switch (widget.errorCode) {
        case 01:
          errorAsset = "assets/svg/undraw_starry_window_ppm0.svg";
          errorMessage = local.translate("error_screen_error_01");
          break;
        case 02:
          errorAsset = "assets/svg/undraw_Taken_re_yn20.svg";
          errorMessage = local.translate("error_screen_error_02");
          break;
        case 03:
          errorAsset = "assets/svg/undraw_Notify_re_65on.svg";
          errorMessage = local.translate("error_screen_error_03");
          break;
        case 05:
          errorAsset = "assets/svg/undraw_access_denied_6w73.svg";
          errorMessage = local.translate("error_screen_error_05");
          break;
        case 06:
          errorAsset = "assets/svg/undraw_cancel_u1it.svg";
          errorMessage = local.translate("error_screen_error_06");
          break;
        case 07:
          errorAsset = "assets/svg/undraw_No_data_re_kwbl.svg";
          errorMessage = local.translate("error_screen_error_07");
          break;
        default:
          errorAsset = "assets/svg/undraw_Faq_re_31cw.svg";
          errorMessage = local.translate("error_screen_error_default");
          break;
      }
      DataManager.setErrorCode(widget.errorCode);
      errorImage = SvgPicture.asset(
        errorAsset,
        height: size.height * .3,
        width: size.width,
      );
      init = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kDarkBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(0, size.height * .15, 0, 0),
                    child: errorImage,
                  ),
                  SizedBox(height: size.height * .025),
                  Row(
                    children: <Widget>[
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 50,
                              color: const Color(0xffffffff).withOpacity(.87),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  SizedBox(height: size.height * .025),
                  Text(
                    errorMessage,
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: 24,
                          color: const Color(0xFFFFFFFF).withOpacity(.54),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: size.height * .025),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          DataManager.appReset(context);
                        },
                        
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5),
                          backgroundColor:
                              MaterialStateProperty.all(kDarkDefaultColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        child: SizedBox(
                          height: size.height * .05,
                          child: Center(
                            child: Text(
                              buttonText,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(
                                    fontSize: 24,
                                    color: const Color(0xFFFFFFFF).withOpacity(.87),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
