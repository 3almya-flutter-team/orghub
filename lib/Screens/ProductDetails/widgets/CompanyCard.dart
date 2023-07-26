import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orghub/Helpers/app_theme.dart';

Widget companyCard(
    {BuildContext context,
    String name,
    String img,
    Function onTap,
    Function onWhatsAppTap,
    Function onChatTapped,
    Function onCallTapped}) {
  return Padding(
     padding: const EdgeInsets.symmetric(vertical: 8),
    child: InkWell(
      onTap: onTap,
          child: Container(
        decoration: BoxDecoration(
          boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 10.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: Offset(
              1.0, // Move to right 10  horizontally
              1.0, // Move to bottom 10 Vertically
            ),
          )
        ],
          color: AppTheme.decorationColor,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        height: 80,
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
                    color: AppTheme.decorationColor,
                    image: DecorationImage(
                        image: NetworkImage(img), fit: BoxFit.fill)),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 260,
              child: AutoSizeText(
                "$name",
                maxLines: 2,
                minFontSize: 9,
                maxFontSize: 13,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: AppTheme.secondaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
            ),
            InkWell(
              onTap: onWhatsAppTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: AppTheme.containerDecoration,
                child: Center(
                  child: Image.asset("assets/icons/whats.png"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: InkWell(
                onTap: onCallTapped,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: AppTheme.containerDecoration,
                  child: Center(
                    child: Image.asset("assets/icons/phone.png"),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: onChatTapped,
              child: Container(
                width: 40,
                height: 40,
                decoration: AppTheme.containerDecoration,
                child: Center(
                  child: Image.asset("assets/icons/chat.png"),
                ),
              ),
            ),
            SizedBox(
              width: 6,
            ),
          ],
        ),
      ),
    ),
  );
}
