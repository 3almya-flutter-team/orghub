import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';


Widget staticSearchContainer({BuildContext context, Function onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: BoxDecoration(
          color: AppTheme.filledColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 13,
            ),
            Text(
              translator.currentLanguage == "en" ? "Search here" : "ابحث هنا",
              style: TextStyle(
                  color: AppTheme.secondaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: Container(),
            ),
            Icon(
              Icons.search,
              color:AppTheme.primaryColor,
              size: 25,
             ),
            SizedBox(
              width: 13,
            ),
          ],
        )),
  );
}
