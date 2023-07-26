import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/appBar.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Screens/CustomWidgets/StaticSearchContainer.dart';
import 'package:orghub/Screens/SearchPage/view.dart';

AppBar appBar({BuildContext context, String title, bool leading}) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
        color: AppTheme.appBarTextColor,
        fontWeight: FontWeight.w900,
        fontFamily: AppTheme.boldFont,
        fontSize: 15,
      ),
    ),
    elevation: 0,
    backgroundColor: AppTheme.appBarColor,
    automaticallyImplyLeading: false,
    centerTitle: true,
    leading: leading
        ? IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppTheme.appBarTextColor,
              size: 22,
            ),
          )
        : null,
  );
}

Widget clientHomeAppBar({
  BuildContext context,
  Function onFilterTapped,
}) {
  return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            appBarWithAction(
                actionIcon: InkWell(
                  onTap: onFilterTapped,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(
                      "assets/icons/filter.png",
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                context: context,
                leading: false,
                title:
                    translator.currentLanguage == "en" ? "Home" : "الرئيسية"),
            Container(
              // width: MediaQuery.of(context).size.width * .85,
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: staticSearchContainer(
                  context: context,
                  onTap: () {
                    Get.to(SearchScreen());
                  }),
            ),
          ],
        ),
      ));
}

Widget providerHomeAppBar({
  BuildContext context,
  Function onLogoTapped,
  // Function onWalletTapped,
  Function onNotificationsTapped,
}) {
  return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: AppTheme.backGroundColor),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
//                  InkWell(
//                    onTap: onWalletTapped,
//                    child: Padding(
//                      padding: const EdgeInsets.only(right: 8, left: 8),
//                      child: Image(
//                        image: AssetImage(
//                          "assets/icons/wallet.png",
//                        ),
//                        height: 25,
//                        width: 20,
//                      ),
//                    ),
//                  ),
                ],
              ),
            ),
            Text(
              translator.currentLanguage == "en" ? "New orders" : "طلبات جديدة",
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w900,
                fontFamily: AppTheme.boldFont,
                fontSize: 15,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 80, left: 80),
              child: Text(
                translator.currentLanguage == "en"
                    ? "Order can't be moved to sales log unti the client receive acceptance"
                    : "لن يتم نقل الطلب الى سجل المبيعات الا بعد تأكيد العميل لاستلام المنتج",
                style: TextStyle(
                  color: AppTheme.subTitleColor,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppTheme.boldFont,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ));
}
