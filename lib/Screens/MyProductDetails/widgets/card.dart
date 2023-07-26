import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:orghub/Helpers/appBar.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';

Widget myProductDetailsCard({
  BuildContext context,
  Function onDeleteTapped,
  Function onEditTapped,
  String productName,
  String productId,
  String viewers,
  String brand,
  double rate,
  String date,
  String quantity,
  String type,
  String specifications,
  String description,
  String category,
  String subCategory,String price
}) {
  return Material(
    elevation: 2,
    borderRadius: BorderRadius.all(Radius.circular(12),),
    child: Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        color: AppTheme.decorationColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 150,
                  child: Text(
                    productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppTheme.accentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                InkWell(
                  onTap: onDeleteTapped,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: AppTheme.containerDecoration,
                    child: Center(
                      child: Icon(
                        Icons.delete,
                        size: 25,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                InkWell(
                  onTap: onEditTapped,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: AppTheme.containerDecoration,
                    child: Center(
                      child: Icon(
                        Icons.edit,
                        size: 25,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 6, left: 6),
                  child: Icon(
                    Icons.remove_red_eye,
                    color: AppTheme.secondaryColor,
                    size: 15,
                  ),
                ),
                Text(
                  viewers,
                  style: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  date,
                  style: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                StarRating(
                  size: 20.0,
                  rating: rate,
                  color: Color(
                    getColorHexFromStr("#FFD500"),
                  ),
                  starCount: 5,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  rate.toString(),
                  style: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            _item(translator.currentLanguage == "en" ? "Ads id" : "رقم الاعلان",
                productId),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _item(
                    translator.currentLanguage == "en" ? "Brand" : "الماركة", brand),
                Text("$price",style: TextStyle(
                  color: AppTheme.priceColor,fontWeight: FontWeight.w900,fontSize: 20
                ),)
              ],
            ),
            _item(
                translator.currentLanguage == "en" ? "Brand" : "الماركة", brand),
            _item(translator.currentLanguage == "en" ? "Quantity" : "الكمية",
                quantity),
            _item(translator.currentLanguage == "en" ? "Type" : "النوع", type),
            _item(
                translator.currentLanguage == "en"
                    ? "Specifications"
                    : "المواصفات",
                specifications),
            Padding(
              padding: const EdgeInsets.only(right: 6, left: 6),
              child: Container(
                width: MediaQuery.of(context).size.width - 30,
                child: Text(
                  description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    decoration: AppTheme.containerDecoration,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: Text(
                          category,
                          style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  decoration: AppTheme.containerDecoration,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Text(
                        subCategory,
                        style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _item(String key, String val) {
  return Row(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 6, left: 6),
        child: Text(
          key + " : ",
          style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w700),
        ),
      ),
      Text(
        val,
        style: TextStyle(
            color: AppTheme.accentColor,
            fontSize: 12,
            fontWeight: FontWeight.w600),
      ),
    ],
  );
}
