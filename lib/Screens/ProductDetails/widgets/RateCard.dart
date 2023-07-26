import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:orghub/Helpers/txt.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
import 'package:orghub/Screens/CustomWidgets/TextFields.dart';

Widget addRateCard(
    {BuildContext context,
    bool isLoading,
    bool withShadow,
    Function onAddCommentTapped,
    Function onRatingUpdate,
    TextEditingController controller}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Container(
        decoration: BoxDecoration(
          boxShadow: !withShadow
              ? []
              : [
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
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          color: AppTheme.decorationColor,
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: translator.currentLanguage == "en"
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: !withShadow
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Center(
                        child: Text(
                          translator.currentLanguage == "en"
                              ? "Add rate "
                              : "اضف تقييم ",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : titleText(
                      translator.currentLanguage == "en"
                          ? "Add rate to product"
                          : "أضف تقيم للمنتج",
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 16),
              child: RatingBar(
                initialRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                // itemBuilder: (context, index) => Icon(
                //   Icons.star,
                //   color: AppTheme.primaryColor,
                // ),
                unratedColor: Color(
                  getColorHexFromStr("#B8C0D3"),
                ),
                onRatingUpdate: onRatingUpdate, ratingWidget: null,
              ),
            ),
            rateTextField(
              context: context,
              controller: controller,
            ),
            isLoading
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SpinKitCircle(
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                    ),
                  )
                : dialogBtn(
                    context,
                    translator.currentLanguage == "en" ? "Send" : "ارسال",
                    onAddCommentTapped),
          ],
        )),
  );
}
