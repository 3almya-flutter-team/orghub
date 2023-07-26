import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';

Widget myCommentsCard(
    {BuildContext context,
    String img,
    String name,
    String date,
    String comment,
    dynamic stars}) {
  return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    image: DecorationImage(
                        image: NetworkImage(img), fit: BoxFit.cover),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.filledColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 6, left: 6, top: 5, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                name??"",
                                style: TextStyle(
                                  color: AppTheme.secondaryColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              StarRating(
                                size: 15.0,
                                rating: stars is double
                                    ? stars
                                    : double.parse(stars.toString()),
                                color: Color(
                                  getColorHexFromStr("#F9EA5B"),
                                ),
                                starCount: 5,
                              ),
                            ],
                          ),
                          Text(
                            comment ??"",
                            style: TextStyle(
                              color: Color(getColorHexFromStr("#787878")),
                              fontSize: 10,
                              // fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
          Align(
            alignment: translator.currentLanguage == "en"
                ? Alignment.topRight
                : Alignment.topLeft,
            child: Padding(
              padding: translator.currentLanguage == "en"
                  ? EdgeInsets.only(right: 25, top: 12)
                  : EdgeInsets.only(left: 25, top: 12),
              child: Text(
                date.split(" ")[0],
                style: TextStyle(
                    color: AppTheme.secondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              ),
            ),
          ),
        ],
      ));
}
