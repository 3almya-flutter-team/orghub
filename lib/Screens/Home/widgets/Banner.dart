import 'package:flutter/material.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';

Widget homeBanner({BuildContext context ,String img}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 180,
    margin: EdgeInsets.symmetric(vertical: 15),
    decoration: BoxDecoration(
        color: Colors.grey,
        image: DecorationImage(
            image: NetworkImage(
                img),
            fit: BoxFit.cover)),
//    child: Align(
//      alignment: Alignment.bottomLeft,
//      child: Container(
//        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//        width: 120,
//        height: 40,
//        child: Center(
//          child: InkWell(
//            onTap: onBuyNowTapped,
//            child: Text(
//              translator.currentLanguage == "en" ? "Buy now" : 'اشتري الأن',
//              style: TextStyle(color: Colors.white, fontSize: 12),
//            ),
//          ),
//        ),
//        decoration: BoxDecoration(
//            borderRadius: BorderRadius.circular(20),
//            color: Colors.white10.withOpacity(0.6)),
//      ),
//    ),
  );
}
