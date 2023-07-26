import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orghub/Helpers/app_theme.dart';

Widget appInfoItem({BuildContext context, String title,subTitle}) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 8, left: 8, top: 5),
              child: Container(
                  height: 10,
                  width: 10,
                  child: CircleAvatar(
                    backgroundColor: AppTheme.accentColor,
                  ))),
          Container(
            width: MediaQuery.of(context).size.width - 50,
            child:Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ), Text(
                  subTitle,
                  style: TextStyle(
                    color: AppTheme.secondaryColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    ),
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(color: AppTheme.backGroundColor),
  );
}
