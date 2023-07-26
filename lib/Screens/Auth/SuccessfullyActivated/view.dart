import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Screens/Auth/card.dart';
import 'package:orghub/Screens/BottomNavigation/view.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';

class SuccessfullyActivatedView extends StatefulWidget {
  final String type;

  const SuccessfullyActivatedView({Key key, this.type}) : super(key: key);
  @override
  _SuccessfullyActivatedViewState createState() =>
      _SuccessfullyActivatedViewState();
}

class _SuccessfullyActivatedViewState extends State<SuccessfullyActivatedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              authCard(
                context: context,
                onTap: () {
                  Get.back();
                },
                key: " ",
                val: "",
                isIntro: false,
                type: translator.currentLanguage == "en" ? "" : "",
              ),
              _txt(
                translator.currentLanguage == "en"
                    ? "Dear customer"
                    : "عميلنا العزيز",
              ),
              _txt(
             widget.type,
              ),
              Expanded(child: Container()),
              // Container(
              //   height: MediaQuery.of(context).size.height * .6 - 220,
              // ),
              btn(
                context,
                translator.currentLanguage == "en" ? "Continue" : "استمرار",
                () {
                  Get.to(BottomNavigationView(),);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _txt(String txt) {
    return Text(
      txt,
      style: TextStyle(
        color: AppTheme.accentColor,
        fontSize: 24,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
