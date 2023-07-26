import 'package:flutter/material.dart';
import 'package:orghub/Helpers/colors.dart';

class AppTheme {
  AppTheme._();
  static Color primaryColor = Color(getColorHexFromStr("#CF0C2E"));
  static Color accentColor = Color(getColorHexFromStr("#2F2F2F"));
  static Color secondaryColor = Color(getColorHexFromStr("#929DA3"));
  static Color secondary2Color = Color(getColorHexFromStr("#B5B5B5"));
  static Color thirdColor = Color(getColorHexFromStr("#F6F7FA"));
  static Color backGroundColor = Color(getColorHexFromStr("#FFFFFF"));
  static Color decorationColor = Color(getColorHexFromStr("#FFFFFF"));
  static Color filledColor = Color(getColorHexFromStr("#F8F8F8"));
  static Color mainButtonColor = Color.fromARGB(0, 113, 202, 196);
  static Color acceptButtonColor = Color(getColorHexFromStr("#FFD32A"));
  static Color btnColor = Color(getColorHexFromStr("#01AAE5"));
  static Color subTitleColor = Color(getColorHexFromStr("#B5BED1"));
  static Color priceColor = Color(getColorHexFromStr("#63DB73"));
  static Color counterColor = Color(getColorHexFromStr("#4DD894"));
  static Color rejectButtonColor = Color(getColorHexFromStr("#FF3F34"));
  static Color appBarColor = Color(getColorHexFromStr("#FFFFFF"));
  static Color appBarTextColor = Color(getColorHexFromStr("#CF0C2E"));

  static Color inputFilledColor = Color.fromARGB(0, 207, 207, 207);

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'Neosans';
  static const String boldFont = 'Neosans-bold';
  static const String defaultImage =
      "https://cdn.pixabay.com/photo/2016/11/29/06/18/apple-1867762_1280.jpg";
  static const String productImage =
      "https://cdn.pixabay.com/photo/2015/01/21/14/14/imac-606765_1280.jpg";
  static const String defaultPersonImage =
      "https://cdn.pixabay.com/photo/2017/12/31/15/56/portrait-3052641_960_720.jpg";

  // static const TextTheme textTheme = TextTheme(
  //   display1: display1,
  //   headline: headline,
  //   title: title,
  //   subtitle: subtitle,
  //   body2: body2,
  //   body1: body1,
  //   caption: caption,
  // );

  static const TextStyle mainButtonTextStyle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 15,
    letterSpacing: -0.31,
    height: 19,
    color: Colors.white,
  );

  static TextStyle inputTextStyle = TextStyle(
    fontFamily: fontName,
    fontSize: 10,
    letterSpacing: -0.17,
    height: 10,
    color: Colors.white,
  );

  static TextStyle inputHintStyle = TextStyle(
    fontFamily: fontName,
    fontSize: 8,
    letterSpacing: -0.17,
    height: 10,
    color: Color(getColorHexFromStr("#7C8184")),
  );

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );
  static BoxDecoration containerDecoration = BoxDecoration(
    color: AppTheme.filledColor,
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  );
  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );
}
