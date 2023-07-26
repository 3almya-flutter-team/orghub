import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Screens/UpdatePassword/view.dart';

Widget _item({BuildContext context, String title, String subTitle}) {
  return Padding(
    padding: const EdgeInsets.only(right: 12, left: 12, top: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.w800,
              fontSize: 14),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          subTitle,
          style: TextStyle(
              color: AppTheme.subTitleColor,
              fontWeight: FontWeight.w800,
              fontSize: 14),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          height: .5,
          color: AppTheme.secondaryColor,
        )
      ],
    ),
  );
}

Widget staticChangePasswordContainer(BuildContext context){
  return  Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width - 60,
        child: _item(
            context: context,
            title: translator.currentLanguage == "en"
                ? "Password"
                : "كلمة المرور",
            subTitle: "************"),
      ),
      IconButton(
        icon: Icon(
          Icons.edit,
          color: AppTheme.accentColor,
          size: 25,
        ),
        onPressed: () {
Get.to(UpdatePasswordView(),);
        },
      )
    ],
  );
}