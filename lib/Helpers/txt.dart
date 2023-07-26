import 'package:flutter/material.dart';
import 'package:orghub/Helpers/app_theme.dart';



Widget titleText(String txt) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      txt,
      style: TextStyle(
          color: AppTheme.accentColor,
          fontSize: 14,
          fontWeight: FontWeight.w900),
    ),
  );
}

