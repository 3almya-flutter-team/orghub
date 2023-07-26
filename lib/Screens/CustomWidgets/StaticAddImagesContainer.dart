import 'package:flutter/material.dart';
import 'package:orghub/Helpers/app_theme.dart';

Widget staticAddImagesContainer({BuildContext context,Function onCameraTapped}){
  return InkWell(
    onTap:onCameraTapped,
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
            border:
            Border.all(color: Colors.grey, width: .3)),
        width: MediaQuery.of(context).size.width * .28,
        height: MediaQuery.of(context).size.width * .28,
        child: Center(
          child: Icon(Icons.add_a_photo,
              size: 35, color: AppTheme.secondaryColor),
        ),
      ),
    ),
  );
}
