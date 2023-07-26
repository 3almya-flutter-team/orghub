import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';

Widget mainCatWidget({
  BuildContext context,
  Function onTap,
  String img,
  String name,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: MediaQuery.of(context).size.width /3,
        margin: EdgeInsets.all(2),
        
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(getColorHexFromStr("#E9E9E9")),
          ),
          color: Color(getColorHexFromStr("#FAFAFA")),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            

            Image.network(
              img,
              width: 90,
              height: 70,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .28,
              child: Center(
                child: AutoSizeText(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    fontFamily: AppTheme.boldFont,
                  ),
                  maxFontSize: 14,
                  minFontSize: 9,
                ),
              ),
            ),
            SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    ),
  );
}

