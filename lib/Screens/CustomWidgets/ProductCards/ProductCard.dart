import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';

Widget productCard(
    {BuildContext context,
    String name,
    String address,
    String img,
    String brandName,
    @required String organizationName,
    String description,
    String price,
    String currency,
    bool isFav,
    Function onTap,
    bool isMine,
    Function onToggleTapped}) {
  return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Container(
      // height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 10.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: Offset(
              2.0, // Move to right 10  horizontally
              2.0, // Move to bottom 10 Vertically
            ),
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                height: 100,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  image: DecorationImage(
                    // image: AssetImage("assets/icons/iphone.png"),
                    image: NetworkImage(img),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // SizedBox(width: 2,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 180,
                        child: Text(
                          name ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: AppTheme.boldFont,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                          maxLines: 1,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 8, left: 8),
                          child: IconButton(
                            onPressed: onToggleTapped,
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: AppTheme.primaryColor,
                            ),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 15,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 135,
                        child: AutoSizeText(
                          address ?? "",
                          maxLines: 1,
                          minFontSize: 9,
                          maxFontSize: 13,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppTheme.secondaryColor,
                            fontSize: 12,
                            fontFamily: AppTheme.fontName,
                            // fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  isMine
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width - 130,
                          margin: EdgeInsets.all(3),
                          child: AutoSizeText(
                            brandName ?? "",
                            maxLines: 1,
                            minFontSize: 9,
                            maxFontSize: 12,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppTheme.fontName,
                            ),
                          ),
                        ),
                  isMine
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width - 130,
                          margin: EdgeInsets.all(3),
                          child: AutoSizeText(
                            organizationName ?? "",
                            maxLines: 1,
                            minFontSize: 9,
                            maxFontSize: 12,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppTheme.fontName,
                            ),
                          ),
                        ),
                  Container(
                    width: MediaQuery.of(context).size.width - 130,
                    child: AutoSizeText(
                      description ?? "",
                      maxLines: 2,
                      minFontSize: 9,
                      maxFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(getColorHexFromStr("#777777")),
                        fontSize: 13,
                        fontFamily: AppTheme.fontName,
                        // fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  price == null || price == ""
                      ? Container(
                          width: MediaQuery.of(context).size.width - 130,
                          margin: EdgeInsets.all(4),
                          child: AutoSizeText(
                            "",
                            maxLines: 1,
                            minFontSize: 9,
                            maxFontSize: 12,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppTheme.priceColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w900),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width - 130,
                          margin: EdgeInsets.all(4),
                          child: AutoSizeText(
                            // "$price ${translator.currentLanguage == "en" ? "Sar" : "رس"}",
                            "$price $currency",
                            maxLines: 1,
                            minFontSize: 9,
                            maxFontSize: 12,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppTheme.priceColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
