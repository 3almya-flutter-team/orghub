import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:orghub/Helpers/app_theme.dart';

Widget categoriesCard({
  BuildContext context,
  Function onTap,
  String img,
  String name,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * .30,
          // height: 90,
          margin: EdgeInsets.only(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Center(
                    child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                      image: DecorationImage(
                          image: NetworkImage(
                            img,
                          ),
                          fit: BoxFit.cover)),
                )),
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
    ),
  );
}
//
//Widget productCardWithCartStatus(
//    {BuildContext context,
//      Function onTap,
//      String img,
//      String productName,
//      String price,
//      bool cartStatus}) {
//  return InkWell(
//    onTap: onTap,
//    child: Padding(
//      padding: const EdgeInsets.all(2.0),
//      child: Card(
//        elevation: 1,
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(6),
//        ),
//        child: Container(
//          width: MediaQuery.of(context).size.width * .30,
//          // height: 90,
//          margin: EdgeInsets.only(),
//          decoration: BoxDecoration(
//            borderRadius: BorderRadius.circular(6),
//          ),
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Expanded(
//                child: Center(
//                    child:
//                    Container(
//
//                      decoration: BoxDecoration(
//                          borderRadius: BorderRadius.only(
//                            topLeft: Radius.circular(6),
//                            topRight: Radius.circular(6),
//                          ),
//                          image: DecorationImage(
//                              image: NetworkImage(
//                                img,
//                              ),fit: BoxFit.cover
//                          )
//                      ),
//                    )
//                ),
//
//              ),
//              Padding(
//                padding: const EdgeInsets.only(right: 8, left: 8),
//                child: Container(
//                  width: MediaQuery.of(context).size.width * .28,
//                  child: AutoSizeText(
//                    productName,
//                    maxLines: 1,
//                    overflow: TextOverflow.ellipsis,
//                    style: TextStyle(
//                      color: AppTheme.primaryColor,
//                      fontSize: 14,
//                      fontWeight: FontWeight.bold,
//                      fontFamily: AppTheme.boldFont,
//                    ),
//                    maxFontSize: 14,
//                    minFontSize: 9,
//                  ),
//                ),
//              ),
//              Row(
//                children: <Widget>[
//                  SizedBox(
//                    width: 6,
//                  ),
//                  Container(
//                    width: MediaQuery.of(context).size.width * .28 - 30,
//                    child: AutoSizeText(
//                      "$price  ${translator.currentLanguage == "en" ? "Sar" : "ر س"}",
//                      overflow: TextOverflow.ellipsis,
//                      style: TextStyle(
//                          color: AppTheme.priceColor,
//                          fontWeight: FontWeight.w700,
//                          fontFamily: AppTheme.fontName,
//                          fontSize: 12),
//                      maxLines: 1,
//                      minFontSize: 9,
//                      maxFontSize: 13,
//                    ),
//                  ),
//                  Expanded(
//                    child: Container(),
//                  ),
//                  cartStatus
//                      ? Icon(
//                    Icons.shopping_cart,
//                    size: 20,
//                    color: AppTheme.secondaryColor,
//                  )
//                      : Container(),
//                  SizedBox(
//                    width: 6,
//                  ),
//                ],
//              ),
//              SizedBox(height: 4,),
//            ],
//          ),
//        ),
//      ),
//    ),
//  );
//}
