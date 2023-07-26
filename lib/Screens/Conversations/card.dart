import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';

Widget conversationsCard(
    {BuildContext context,
    String name,
    String body,
    String img,
    String date,
    Function onTap,
    Function onDeleteTapped}) {
  return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
          boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.1),
            blurRadius: 7.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: Offset(
              1.0, // Move to right 10  horizontally
              1.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      
      height: 100,
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: DecorationImage(
                        image: NetworkImage(img), fit: BoxFit.fill)),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 150,
                    child: Text(
                      name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w800),
                      maxLines: 1,
                    ),
                  ),
                  Align(
                    alignment: translator.currentLanguage == "en"
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      date,
                      style: TextStyle(
                          color: Color(getColorHexFromStr("#B7B7B7")),
                          fontSize: 10,
                          // fontWeight: FontWeight.w600,
                          fontFamily: AppTheme.fontName,
                          ),
                    ),
                  ),
                  AutoSizeText(
                    body,
                    maxLines: 2,
                    minFontSize: 9,
                    maxFontSize: 13,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                       color: Color(getColorHexFromStr("#B7B7B7")),
                        fontSize: 11,
                        // fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: InkWell(
                onTap: onDeleteTapped,
                child: Image.asset(
                  "assets/icons/delete11.png",
                  width: 40,
                  height: 40,
                  // color: AppTheme.secondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
