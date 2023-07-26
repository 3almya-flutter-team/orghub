import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';


void displayDefultBottomSheet(
    {@required BuildContext context,
    @required String text,
    @required Function onClicked}) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          padding: EdgeInsets.all(9),
          color: Colors.grey[300],
          child: Container(
            width: MediaQuery.of(context).size.width,
            // height: 50,
            decoration: BoxDecoration(
              // color: Colors.grey[300],
              color: Color(getColorHexFromStr("#F2F2E5")),
              // border: Border.all(),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(CupertinoIcons.location),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: AutoSizeText(
                          "برجاء تفعيل خدمه الموقع وذلك للسماح بتحديد موقع الاعلان",
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: onClicked,
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "اعدادات التطبيق",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
