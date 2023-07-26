import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';

Widget showAllText(
    {BuildContext context, Function onShowAllTapped, String title}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      SizedBox(
        width: 14,
      ),
      Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontFamily: AppTheme.boldFont,
          fontSize: 17,
        ),
      ),
      Expanded(
        child: Container(),
      ),
      InkWell(
        onTap: onShowAllTapped,
        child: Text(
          translator.currentLanguage == "en" ? "Show more" : "عرض المزيد",
          style: TextStyle(
            color: Color(
              getColorHexFromStr("#C7C7C7"),
            ),
            fontWeight: FontWeight.w900,
            fontFamily: AppTheme.fontName,
            fontSize: 12,
          ),
        ),
      ),
      SizedBox(
        width: 14,
      ),
    ],
  );
}
