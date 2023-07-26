import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Screens/Complaints&Suggestions/view.dart';

Widget authCard(
    {BuildContext context,
    String type,
    String key,
    String val,
    bool isIntro,
    Function onTap,
    Function changeLang}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height / 2,
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/icons/auth-bg.png"), fit: BoxFit.fill),
    ),
    child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  onPressed: changeLang,
                  child: Container(
                    // width: 40,
                    // height: 40,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(10),

                    decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        translator.currentLanguage == 'ar'
                            ? "EN"
                            : "اللغه العربيه",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(ComplaintsView(type: 'visitor',));
                  },
                  child: Icon(
                    CupertinoIcons.mail_solid,
                    size: 50,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            "assets/icons/logox.png",
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.width / 3,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            type ?? "",
            style: TextStyle(
              color: AppTheme.accentColor,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          !isIntro
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      key,
                      style: TextStyle(
                          color: AppTheme.accentColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: onTap,
                      child: Text(
                        val,
                        style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 15,
                            // decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              : Text(
                  translator.currentLanguage == "en"
                      ? "Register types"
                      : "انواع التسجيل",
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
        ],
      ),
    ),
  );
}
