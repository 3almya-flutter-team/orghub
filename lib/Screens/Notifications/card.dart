import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';

Widget notificationsCard(
    {BuildContext context,
    String name,
    String body,
    String img,
    Function onTap,
    Function onDeleteTapped}) {
  return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Container(
      color: AppTheme.decorationColor,
      height: 80,
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.5),
                        blurRadius: 20.0, // soften the shadow
                        spreadRadius: 0.0, //extend the shadow
                        offset: Offset(
                          4.0, // Move to right 10  horizontally
                          4.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                    color: AppTheme.decorationColor,
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
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AutoSizeText(
                    body,
                    maxLines: 2,
                    minFontSize: 9,
                    maxFontSize: 13,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(getColorHexFromStr("#848584")),
                      fontSize: 11,
                      fontFamily: AppTheme.fontName,
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
