import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/OfferDetail/AcceptOffer/bloc.dart';
import 'package:orghub/Screens/OfferDetail/AcceptOffer/events.dart';
import 'package:orghub/Screens/OfferDetail/AcceptOffer/states.dart';
import 'package:orghub/Screens/OfferDetail/DeleteOffer/bloc.dart';
import 'package:orghub/Screens/OfferDetail/DeleteOffer/events.dart';
import 'package:orghub/Screens/OfferDetail/DeleteOffer/states.dart';
import 'package:orghub/Screens/OfferDetail/bloc.dart';
import 'package:orghub/Screens/OfferDetail/events.dart';
import 'package:orghub/Screens/OfferDetail/states.dart';
import 'package:orghub/Screens/OrdersHistory/view.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';
import 'package:toast/toast.dart';

class OfferDetailView extends StatefulWidget {
  final int offerId;
  final String from;
  OfferDetailView({@required this.offerId, this.from});
  @override
  _OfferDetailViewState createState() => _OfferDetailViewState();
}

class _OfferDetailViewState extends State<OfferDetailView> {
  GetSingleOfferBloc getSingleOfferBloc =
      kiwi.KiwiContainer().resolve<GetSingleOfferBloc>();
  AcceptOfferBloc acceptOfferBloc =
      kiwi.KiwiContainer().resolve<AcceptOfferBloc>();
  DeleteOfferBloc deleteOfferBloc =
      kiwi.KiwiContainer().resolve<DeleteOfferBloc>();

  @override
  void initState() {
    super.initState();
    getSingleOfferBloc.add(
      GetSingleOfferEventsStart(
        offerId: widget.offerId,
      ),
    );
  }

  @override
  void dispose() {
    getSingleOfferBloc.close();
    deleteOfferBloc.close();
    acceptOfferBloc.close();
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
        backgroundColor: Color(getColorHexFromStr("F5FAFD")),
        bottomNavigationBar: Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: widget.from != "product"
                ? BlocConsumer(
                    bloc: deleteOfferBloc,
                    builder: (context, state) {
                      if (state is DeleteOfferStatesStart)
                        return Center(
                          child: SpinKitCircle(
                            color: AppTheme.primaryColor,
                            size: 40.0,
                          ),
                        );
                      else {
                        return InkWell(
                          onTap: () {
                            deleteOfferBloc.add(DeleteOfferEventsStart(
                                offerId: widget.offerId));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            height: 50,
                            margin: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                translator.currentLanguage == "en"
                                    ? "Cancel Offer "
                                    : "الغاء العرض",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    listener: (context, state) {
                      if (state is DeleteOfferStatesSuccess) {
                        Toast.show(
                            translator.currentLanguage == "en"
                                ? "Done"
                                : "تم الغاء العرض بنجاح",
                            context);
                        Get.to(OrderHistory());
                      } else if (state is DeleteOfferStatesFailed) {
                        _handleError(state: state, context: context);
                      }
                    },
                  )
                : BlocConsumer(
                    bloc: acceptOfferBloc,
                    builder: (context, state) {
                      if (state is AcceptOfferStatesStart)
                        return Center(
                          child: SpinKitCircle(
                            color: AppTheme.primaryColor,
                            size: 40.0,
                          ),
                        );
                      else {
                        return InkWell(
                          onTap: () {
                            acceptOfferBloc.add(AcceptOfferEventsStart(
                                offerId: widget.offerId));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(15)),
                            height: 50,
                            margin: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                translator.currentLanguage == "en"
                                    ? "Accept Offer "
                                    : "قبول العرض",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    listener: (context, state) {
                      if (state is AcceptOfferStatesSuccess) {
                        Toast.show(
                            translator.currentLanguage == "en"
                                ? "Done"
                                : "تم قبول العرض بنجاح",
                            context);
                        Get.to(OrderHistory());
                      } else if (state is AcceptOfferStatesFailed) {
                        _handleError(state: state, context: context);
                      }
                    },
                  ),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppTheme.appBarColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 17,
              color: AppTheme.appBarTextColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            translator.currentLanguage == "en"
                ? "Offer Detail"
                : "تفاصيل العرض",
            style: TextStyle(
                color: AppTheme.appBarTextColor,
                fontSize: 20,
                fontFamily: 'NeoSans',
                fontWeight: FontWeight.w300),
          ),
        ),
        body: BlocBuilder(
            bloc: getSingleOfferBloc,
            builder: (context, state) {
              if (state is GetSingleOfferStatesStart) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SpinKitThreeBounce(
                    color: AppTheme.primaryColor,
                    size: 30,
                  ),
                );
              } else if (state is GetSingleOfferStatesSuccess) {
                return Container(
                  // height: MediaQuery.of(context).size.height/3,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            translator.currentLanguage == "en"
                                ? "Product Name :"
                                : "اسم المنتج:",
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(state.offerData.ad.name),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            translator.currentLanguage == "en"
                                ? "Offer Price :"
                                : "المبلغ المعروض :",
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(state.offerData.offerPrice),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            translator.currentLanguage == "en"
                                ? "Status :"
                                : "الحاله:",
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(state.offerData.transOfferStatus),
                        ],
                      ),
                    ],
                  ),
                );
              } else if (state is GetSingleOfferStatesFailed) {
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

  void _handleError({BuildContext context, dynamic state}) {
    if (state.errType == 0) {
      FlashHelper.infoBar(
        context,
        message: translator.currentLanguage == "ar"
            ? "من فضلك تاكد من الاتصال بالانترنت"
            : "PLEASE CHECK YOUR NETWORK CONNECTION",
      );
    } else if (state.errType == 1) {
      FlashHelper.errorBar(context, message: state.msg ?? "");
      // }
    } else {
      // other error
      FlashHelper.errorBar(context, message: state.msg ?? "");
    }
  }

  Widget _botton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          BlocConsumer(
            bloc: deleteOfferBloc,
            builder: (context, state) {
              if (state is DeleteOfferStatesStart)
                return Center(
                  child: SpinKitCircle(
                    color: AppTheme.primaryColor,
                    size: 40.0,
                  ),
                );
              else {
                return InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(getColorHexFromStr('67C952')),
                        borderRadius: BorderRadius.circular(15)),
                    height: 50,
                    margin: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        translator.currentLanguage == "en"
                            ? "Cancel Offer "
                            : "الغاء العرض",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              }
            },
            listener: (context, state) {
              if (state is DeleteOfferStatesSuccess) {
                Toast.show(
                    translator.currentLanguage == "en"
                        ? "Done"
                        : "تم الغاء العرض بنجاح",
                    context);
              } else if (state is DeleteOfferStatesFailed) {
                _handleError(state: state, context: context);
              }
            },
          ),
          widget.from == "product"
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15)),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      translator.currentLanguage == "en"
                          ? "Accept Offer"
                          : "الموافقه على العرض",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  // Widget _orderStatus({SingleBuyingOrder order}) {
  //   return ListView.builder(
  //       shrinkWrap: true,
  //       primary: false,
  //       itemCount: status.length,
  //       itemBuilder: (context, index) {
  //         return Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Column(
  //             children: <Widget>[
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: <Widget>[
  //                   Container(
  //                     height: 25,
  //                     width: 25,
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       border: Border.all(
  //                         width: 1,
  //                         color: status[index]['isActive']
  //                             ? Color(
  //                                 getColorHexFromStr("6DD77F"),
  //                               )
  //                             : Colors.grey,
  //                       ),
  //                     ),
  //                     child: Icon(
  //                       Icons.done,
  //                       size: 20,
  //                       color: status[index]['isActive']
  //                           ? Color(
  //                               getColorHexFromStr("6DD77F"),
  //                             )
  //                           : Colors.grey,
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 30,
  //                   ),
  //                   Text(
  //                     status[index]['type'].toString(),
  //                     style: TextStyle(
  //                         color: status[index]['isActive']
  //                             ? Color(
  //                                 getColorHexFromStr("6DD77F"),
  //                               )
  //                             : Colors.grey,
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }

}
