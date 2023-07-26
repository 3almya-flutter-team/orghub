import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';


Future<void> deleteDialog({BuildContext context,Function onDeleteTapped}) {
  return
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: new Text(
              translator.currentLanguage == 'ar' ? "تأكيد الحذف" : "Confirm deletion",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryColor,
                  fontFamily: AppTheme.fontName),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: onDeleteTapped,
                child: new Text(
                  translator.currentLanguage == 'ar' ? "حذف" : "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text(
                  translator.currentLanguage == 'ar' ? "الغاء" : "Cancel",
                  style: TextStyle(color: AppTheme.secondaryColor),
                ),
              ),
            ],
          );
        });
}