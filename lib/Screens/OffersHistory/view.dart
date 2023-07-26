import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/CustomWidgets/AppBar.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Screens/OfferDetail/view.dart';
import 'package:orghub/Screens/OffersHistory/bloc.dart';
import 'package:orghub/Screens/OffersHistory/events.dart';
import 'package:orghub/Screens/OffersHistory/states.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';

class MyOffersView extends StatefulWidget {
  @override
  _MyOffersViewState createState() => _MyOffersViewState();
}

class _MyOffersViewState extends State<MyOffersView> {
  GetMyOffersBloc getMyOffersBloc =
      kiwi.KiwiContainer().resolve<GetMyOffersBloc>();

  @override
  void initState() {
    getMyOffersBloc.add(GetMyOffersEventsSatart());
    super.initState();
  }

  @override
  void dispose() {
    getMyOffersBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);
    return Directionality(
      textDirection: translator.currentLanguage == "en"
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        appBar: appBar(
          context: context,
          leading: true,
          title: translator.currentLanguage == "en" ? "My Offers" : "عروضى",
        ),
        body: BlocBuilder(
            bloc: getMyOffersBloc,
            builder: (context, state) {
              if (state is GetMyOffersStatesStart) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SpinKitThreeBounce(
                    color: AppTheme.primaryColor,
                    size: 30,
                  ),
                );
              } else if (state is GetMyOffersStatesSuccess) {
                return state.offers.isEmpty
                    ? Center(
                        child: Text(translator.currentLanguage == "en"
                            ? "Empty"
                            : "لايوجد"),
                      )
                    : ListView.builder(
                        itemCount: state.offers.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.offers.length,
                            scrollDirection: Axis.vertical,
                            primary: false,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(
                                      OfferDetailView(
                                        offerId: state.offers[index].id,
                                      ),
                                    );
                                  },
                                  child: Directionality(
                                    textDirection:
                                        translator.currentLanguage == "en"
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                    child: Card(
                                      elevation: 1,
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  translator.currentLanguage ==
                                                          "en"
                                                      ? "Product Name :"
                                                      : "اسم المنتج:",
                                                  style: TextStyle(
                                                    color:
                                                        AppTheme.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(state
                                                    .offers[index].ad.name),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  translator.currentLanguage ==
                                                          "en"
                                                      ? "Offer Price"
                                                      : "المبلغ المعروض :",
                                                  style: TextStyle(
                                                    color:
                                                        AppTheme.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(state
                                                    .offers[index].offerPrice),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  translator.currentLanguage ==
                                                          "en"
                                                      ? "Status :"
                                                      : "الحاله:",
                                                  style: TextStyle(
                                                    color:
                                                        AppTheme.primaryColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(state.offers[index]
                                                    .transOfferStatus),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
              } else if (state is GetMyOffersStatesFailed) {
                if (state.errType == 0) {
                  // FlashHelper.errorBar(context,
                  //     message: translator.currentLanguage == 'en'
                  //         ? "Please check your network connection."
                  //         : "برجاء التاكد من الاتصال بالانترنت ");
                  return noInternetWidget(context);
                } else {
                  // FlashHelper.errorBar(context, message: state.msg ?? "");
                  return errorWidget(context, state.msg ?? "",state.statusCode);
                }
              } else {
                // FlashHelper.errorBar(context, message: state.msg ?? "");
                return Container();
              }
            }),
      ),
    );
  }

  bool isFav = true;
}
