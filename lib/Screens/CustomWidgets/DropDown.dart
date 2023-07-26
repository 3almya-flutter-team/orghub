import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';

Widget dropDownContainer({BuildContext context, String txt, Function onTap}) {
  return Padding(
    padding: const EdgeInsets.only(right: 20, left: 20, top: 14),
    child: InkWell(
      onTap: onTap,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: translator.currentLanguage == "en"
                    ? EdgeInsets.only(right: 14)
                    : EdgeInsets.only(left: 14),
                child: Container(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  txt,
                  style: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: translator.currentLanguage == "en"
                    ? EdgeInsets.only(right: 14)
                    : EdgeInsets.only(left: 14),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: AppTheme.secondaryColor,
                ),
              )
            ],
          )),
    ),
  );
}

Widget dialogDropDownContainer(
    {BuildContext context, String txt, Function onTap}) {
  return Padding(
    padding: const EdgeInsets.only(right: 40, left: 40, top: 14),
    child: InkWell(
      onTap: onTap,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: translator.currentLanguage == "en"
                    ? EdgeInsets.only(right: 14)
                    : EdgeInsets.only(left: 14),
                child: Container(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  txt,
                  style: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: translator.currentLanguage == "en"
                    ? EdgeInsets.only(right: 14)
                    : EdgeInsets.only(left: 14),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: AppTheme.secondaryColor,
                ),
              )
            ],
          )),
    ),
  );
}

Widget authDropDownContainer(
    {BuildContext context, String txt, Function onTap}) {
  return Padding(
    padding: const EdgeInsets.only(right: 20, left: 20, top: 14),
    child: InkWell(
      onTap: onTap,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.01, 0.9],
              colors: [

                Color(
                  getColorHexFromStr("#EAEDF2"),
                ),
                Color(
                  getColorHexFromStr("#EEF1F5"),
                ),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: translator.currentLanguage == "en"
                    ? EdgeInsets.only(right: 14)
                    : EdgeInsets.only(left: 14),
                child: Container(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  txt,
                  style: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: translator.currentLanguage == "en"
                    ? EdgeInsets.only(right: 14)
                    : EdgeInsets.only(left: 14),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: AppTheme.secondaryColor,
                ),
              )
            ],
          )),
    ),
  );
}

Widget routeContainer({BuildContext context, String txt, Function onTap}) {
  return Padding(
    padding: const EdgeInsets.only(right: 25, left: 25, bottom: 15),
    child: InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: AppTheme.filledColor,
//          border: Border.all(
//              color:AppTheme.secondaryColor,
//              width: .5),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 60,
            child: Center(
              child: AutoSizeText(
                txt,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                minFontSize: 10,
                maxFontSize: 13,
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  color: AppTheme.secondary2Color,
                  fontSize: 9,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget smallDropDownContainer(
    {BuildContext context, String txt, Function onTap}) {
  return Padding(
    padding: const EdgeInsets.only(right: 10, left: 10, bottom: 15),
    child: InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * .4,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppTheme.secondaryColor, width: .5),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width * .3,
                  child: AutoSizeText(
                    txt,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 10,
                    maxFontSize: 13,
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        color: AppTheme.secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
              ),
//              Expanded(
//                child: Container(),
//              ),
//              Icon(
//                Icons.keyboard_arrow_down,
//                color: AppTheme.secondaryColor,
//              ),
//              SizedBox(
//                width: 10,
//              )
            ],
          ),
        ),
      ),
    ),
  );
}
