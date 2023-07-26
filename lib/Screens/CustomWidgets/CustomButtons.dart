import 'package:flutter/material.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';

Widget btn(BuildContext context, String txt, Function onTap) {
  return Padding(
    padding: const EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 15),
    child: Material(
          child: InkWell(
        onTap: onTap,
        child: Material(
          elevation: 0,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 55,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.5),
                  blurRadius: 20.0, // soften the shadow
                  spreadRadius: 4.0, //extend the shadow
                  offset: Offset(
                    10.0, // Move to right 10  horizontally
                    10.0, // Move to bottom 10 Vertically
                  ),
                )
              ],
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                txt,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget dialogBtn(BuildContext context, String txt, Function onTap) {
  return Padding(
    padding: const EdgeInsets.only(top: 15, bottom: 15),
    child: InkWell(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 35,
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
          color: Color(
            getColorHexFromStr("#CF0C2E"),
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            txt,
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    ),
  );
}

Widget rejectBtn(BuildContext context, String txt, Function onTap) {
  return Padding(
    padding: const EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 15),
    child: InkWell(
      onTap: onTap,
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.01, 0.9],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.

                Color(
                  getColorHexFromStr("#FB1818"),
                ),
                Color(
                  getColorHexFromStr("#FF0101"),
                ),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              txt,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    ),
  );
}
