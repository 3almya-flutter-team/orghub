import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Screens/OrderDetail/ClientCancelOrder/bloc.dart';
import 'package:orghub/Screens/OrderDetail/ClientCancelOrder/events.dart';
import 'package:orghub/Screens/OrderDetail/ClientCancelOrder/states.dart';
import 'package:orghub/Screens/OrderDetail/DeleteOrder/bloc.dart';
import 'package:orghub/Screens/OrderDetail/OrderIsReady/bloc.dart';
import 'package:orghub/Screens/OrderDetail/OrderIsReady/events.dart';
import 'package:orghub/Screens/OrderDetail/OrderIsReady/states.dart';
import 'package:orghub/Screens/OrderDetail/OwnerRefuseOrder/bloc.dart';
import 'package:orghub/Screens/OrderDetail/OwnerRefuseOrder/events.dart';
import 'package:orghub/Screens/OrderDetail/OwnerRefuseOrder/states.dart';
import 'package:orghub/Screens/OrderDetail/Preparing/bloc.dart';
import 'package:orghub/Screens/OrderDetail/Preparing/events.dart';
import 'package:orghub/Screens/OrderDetail/Preparing/states.dart';
import 'package:orghub/Screens/OrderDetail/bloc.dart';
import 'package:orghub/Screens/OrderDetail/events.dart';
import 'package:orghub/Screens/OrderDetail/model.dart';
import 'package:orghub/Screens/OrderDetail/states.dart';
import 'package:orghub/Screens/OtherServices/view.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';
import 'package:toast/toast.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class DetailsOrder extends StatefulWidget {
  final int orderId;
  final String api;
  DetailsOrder({@required this.orderId, this.api});
  @override
  _DetailsOrderState createState() => _DetailsOrderState();
}



class _DetailsOrderState extends State<DetailsOrder> {
  GetSingleBuyinOrder getSingleBuyinOrder =
      kiwi.KiwiContainer().resolve<GetSingleBuyinOrder>();
  ChangeOrderStatusBloc changeOrderStatusBloc =
      kiwi.KiwiContainer().resolve<ChangeOrderStatusBloc>();
  ClientCancelOrderBloc clientCancelOrderBloc =
      kiwi.KiwiContainer().resolve<ClientCancelOrderBloc>();
  DeleteOrderBloc deleteOrderBloc =
      kiwi.KiwiContainer().resolve<DeleteOrderBloc>();
  OwnerRefuseOrderBloc ownerRefuseOrderBloc =
      kiwi.KiwiContainer().resolve<OwnerRefuseOrderBloc>();
  PreparingOrderBloc preparingOrderBloc =
      kiwi.KiwiContainer().resolve<PreparingOrderBloc>();


      

  @override
  void initState() {
    print("=-=-=-= [${widget.api}] =-=-=-=");
    super.initState();
    if (Platform.isAndroid) {
      HttpOverrides.global = new MyHttpOverrides();
    }
    initOrderSocketIo();
    getSingleBuyinOrder.add(
      GetSingleBuyinOrderEventsStart(
        orderId: widget.orderId,
        api: widget.api,
      ),
    );
  }

  Echo echo;

  void initOrderSocketIo() async {
    String token = await Prefs.getStringF("authToken");
    print("=-=-= token =-== order -=-= $token");
    echo = new Echo({
      'broadcaster': 'socket.io',
      'client': IO.io,
      'auth': {
        'headers': {'Authorization': 'Bearer $token'}
      },
      "host": "https://org.taha.rmal.com.sa:6010",
      // "host": "https://orghub.store:6010",
    });

    int userId = await Prefs.getIntF("userId");

    // echo.private('org-notification.18').listen((notification) {
    //   print("=-=-= notification =-=-=--> ${notification.toString()}");
    // });

    echo.private('org-notification.$userId').notification((notification) {
      print("=-=-=-= notification =-=-=> ${notification.toString()}");
      print(
          "=-=-=-= orderStatus =-=-=> ${notification["order_status"].toString()}");
      getSingleBuyinOrder.add(
        GetSingleBuyinOrderEventsUpdated(
          status: notification["order_status"],
        ),
      );
      // setState(() {});
      // status.forEach((element) {
      //   if ((element['status'] as List).contains(notification["order_status"])
      //       // "تم التوريد"
      //       ) {
      //     int index = status.indexWhere((item) => item['id'] == element["id"]);

      //     setState(() {
      //       status[index]['isActive'] = true;
      //     });
      //     for (int x = 0; x < index; x++) {
      //       setState(() {
      //         status[x]['isActive'] = true;
      //       });
      //     }
      //   }
      // });
    });

    // echo.private('org-notification.18').listen("BroadcastNotificationCreated",
    //     (notification) {
    //   print("=-=-=-= notification =-=-=> ${notification.toString()}");
    // });
  }

  @override
  void dispose() {
    getSingleBuyinOrder.close();
    changeOrderStatusBloc.close();
    deleteOrderBloc.close();
    clientCancelOrderBloc.close();
    ownerRefuseOrderBloc.close();
    preparingOrderBloc.close();
    super.dispose();
  }
  /*
   [pending - admin_accept - admin_refuse - client_cancel -
    owner_refuse - shipped - preparing - prepared - supplied - stored - delivered]
   */

  List<Map<String, dynamic>> status = [
    {
      "id": 0,
      "type": "قيد الانتظار",
      "status": ["pending"],
      "isActive": false,
    },
    {
      "id": 1,
      "type": "جاري تجهيز الطلب",
      "status": ["preparing"],
      "isActive": false,
    },
    {
      "id": 2,
      "type": "تم تجهيز الطلب",
      "status": ["prepared"],
      "isActive": false,
    },
    {
      "id": 3,
      "type": "تم التخزين",
      "status": ["stored"],
      "isActive": false,
    },
    {
      "id": 4,
      "type": "تم التوريد",
      "status": ["supplied"],
      "isActive": false,
    },
    {
      "id": 5,
      "type": "تم الشحن",
      "status": ["shipped"],
      "isActive": false,
    },
    {
      "id": 6,
      "type": "تم التوصيل",
      "status": ["delivered"],
      "isActive": false,
    },
    {
      "id": 7,
      "type": "تم الغاء الطلب",
      "status": [
        "admin_accept",
        "admin_refuse",
        "owner_refuse",
        "client_cancel"
      ],
      "isActive": false,
    }
  ];
  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);
    return Directionality(
      textDirection:
                                        translator.currentLanguage == "en"
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color(getColorHexFromStr("F5FAFD")),
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
            translator.currentLanguage == "en" ? "Details" : "التفاصيل",
            style: TextStyle(
                color: AppTheme.appBarTextColor,
                fontSize: 20,
                fontFamily: 'NeoSans',
                fontWeight: FontWeight.w300),
          ),
        ),
        body: BlocBuilder(
            bloc: getSingleBuyinOrder,
            builder: (context, state) {
              if (state is GetSingleBuyinOrderStatesStart) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SpinKitThreeBounce(
                    color: AppTheme.primaryColor,
                    size: 30,
                  ),
                );
              } else if (state is GetSingleBuyinOrderStatesSuccess) {
                status.forEach((element) {
                  if ((element['status'] as List)
                          .contains(state.singleBuyingOrder.orderStatus)
                      // "تم التوريد"
                      ) {
                    int index = status
                        .indexWhere((item) => item['id'] == element["id"]);
                    status[index]['isActive'] = true;

                    // for (int x = 0; x < index; x++) {
                    //   status[x]['isActive'] = false;
                    // }
                  } else {
                    int index = status
                        .indexWhere((item) => item['id'] == element["id"]);
                    status[index]['isActive'] = false;
                  }
                  // if (element["id"] != status[index]['id']) {
                  //     int otherIndex = status
                  //         .indexWhere((item) => item['id'] == element["id"]);
                  //     status[otherIndex]['isActive'] = false;
                  //   }
                });
                return ListView(
                  shrinkWrap: true,
                  primary: true,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              translator.currentLanguage == "en"
                                  ? "Order Detail"
                                  : "تفاصيل الطلب",
                              style: TextStyle(
                                  color: Color(getColorHexFromStr('333333')),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'NeoSans',
                                  fontSize: 15),
                            ),
                          ),
                          _orderDetails(
                              image: state.singleBuyingOrder.image,
                              orderName: state.singleBuyingOrder.bill.name,
                              orderNum: state.singleBuyingOrder.id,
                              stock: state.singleBuyingOrder.bill.qty,
                              totalPrice:
                                  state.singleBuyingOrder.bill.totalAdPrice),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              translator.currentLanguage == "en"
                                  ? "Deliver address :"
                                  : "عنوان التوصيل",
                              style: TextStyle(
                                  color: Color(getColorHexFromStr('333333')),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${state.singleBuyingOrder.address}",
                              style: TextStyle(
                                  color: Color(getColorHexFromStr('848584')),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              translator.currentLanguage == "en"
                                  ? "Order Status"
                                  : "حالة الطلب",
                              style: TextStyle(
                                  color: Color(getColorHexFromStr('333333')),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                          _orderStatus(order: state.singleBuyingOrder),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _botton(
                        state.singleBuyingOrder.orderStatus,
                        state.singleBuyingOrder.isMyAd,
                        state.singleBuyingOrder.isMyOrder,
                      ),
                    ),
                  ],
                );
              } else if (state is GetSingleBuyinOrderStatesFailed) {
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

  Widget _botton(String status, bool isMyAd, bool isMyOrder) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          isMyOrder &&
                  (status == "pending" ||
                      status == "preparing" ||
                      status == "prepared" ||
                      status == "supplied" ||
                      status == "stored" ||
                      status == "admin_accept")
              ? BlocConsumer(
                  bloc: clientCancelOrderBloc,
                  builder: (context, state) {
                    if (state is ClientCancelOrderStatesStart)
                      return Center(
                        child: SpinKitCircle(
                          color: AppTheme.primaryColor,
                          size: 40.0,
                        ),
                      );
                    else {
                      return InkWell(
                        onTap: () {
                          clientCancelOrderBloc.add(
                            ClientCancelOrderEventsStart(
                                orderId: widget.orderId,
                                status: "client_cancel"),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(getColorHexFromStr('67C952')),
                              borderRadius: BorderRadius.circular(15)),
                          height: 50,
                          width: 100,
                          child: Center(
                            child: Text(
                              "الغاء الطلب",
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
                    if (state is ClientCancelOrderStatesSuccess) {
                      Toast.show(
                          translator.currentLanguage == "en"
                              ? "Done"
                              : "تم الغاء الطلب بنجاح",
                          context);
                    } else if (state is ClientCancelOrderStatesFailed) {
                      _handleError(state: state, context: context);
                    }
                  },
                )
              : () {
                  if (status == "pending") {
                    return BlocConsumer(
                      bloc: preparingOrderBloc,
                      builder: (context, state) {
                        if (state is PreparingOrderStatesStart)
                          return Center(
                            child: SpinKitCircle(
                              color: AppTheme.primaryColor,
                              size: 40.0,
                            ),
                          );
                        else {
                          return InkWell(
                            onTap: () {
                              preparingOrderBloc.add(
                                PreparingOrderEventsStart(
                                    orderId: widget.orderId,
                                    status: "preparing"),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(getColorHexFromStr('67C952')),
                                  borderRadius: BorderRadius.circular(15)),
                              height: 50,
                              width: 100,
                              child: Center(
                                child: Text(
                                  "جارى التجهيز",
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
                        if (state is PreparingOrderStatesSuccess) {
                          Toast.show(
                              translator.currentLanguage == "en"
                                  ? "Done"
                                  : "تم عمل الطلب بنجاح",
                              context);
                        } else if (state is PreparingOrderStatesFailed) {
                          _handleError(state: state, context: context);
                        }
                      },
                    );
                  } else if (status == "preparing") {
                    return BlocConsumer(
                      bloc: changeOrderStatusBloc,
                      builder: (context, state) {
                        if (state is ChangeOrderStatusStatesStart)
                          return Center(
                            child: SpinKitCircle(
                              color: AppTheme.primaryColor,
                              size: 40.0,
                            ),
                          );
                        else {
                          return InkWell(
                            onTap: () {
                              changeOrderStatusBloc.add(
                                ChangeOrderStatusEventsStart(
                                    orderId: widget.orderId,
                                    status: "prepared"),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(getColorHexFromStr('67C952')),
                                  borderRadius: BorderRadius.circular(15)),
                              height: 50,
                              width: 150,
                              child: Center(
                                child: Text(
                                  " تم التجهيز",
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
                        if (state is ChangeOrderStatusStatesSuccess) {
                          Toast.show(
                              translator.currentLanguage == "en"
                                  ? "Done"
                                  : "تم عمل الطلب بنجاح",
                              context);
                        } else if (state is ChangeOrderStatusStatesFailed) {
                          _handleError(state: state, context: context);
                        }
                      },
                    );
                  } else if (status == "prepared") {
                    return Container();
                    //  BlocConsumer(
                    //   bloc: ownerRefuseOrderBloc,
                    //   builder: (context, state) {
                    //     if (state is OwnerRefuseOrderStatesStart)
                    //       return Center(
                    //         child: SpinKitCircle(
                    //           color: AppTheme.primaryColor,
                    //           size: 40.0,
                    //         ),
                    //       );
                    //     else {
                    //       return InkWell(
                    //         onTap: () {
                    //           ownerRefuseOrderBloc.add(
                    //             OwnerRefuseOrderEventsStart(
                    //                 orderId: widget.orderId,
                    //                 status: "owner_refuse"),
                    //           );
                    //         },
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //               color: Colors.red,
                    //               borderRadius: BorderRadius.circular(15)),
                    //           height: 50,
                    //           width: 150,
                    //           child: Center(
                    //             child: Text(
                    //               "رفض الطلب",
                    //               style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     }
                    //   },
                    //   listener: (context, state) {
                    //     if (state is OwnerRefuseOrderStatesSuccess) {
                    //       Toast.show(
                    //           translator.currentLanguage == "en"
                    //               ? "Done"
                    //               : "تم عمل الطلب بنجاح",
                    //           context);
                    //     } else if (state is OwnerRefuseOrderStatesFailed) {
                    //       _handleError(state: state, context: context);
                    //     }
                    //   },
                    // );
                  } else {
                    return Container();
                  }
                }(),
          !isMyAd
              ? Container()
              : status == "pending" ||
                      status == "preparing" ||
                      status == "prepared"
                  ? BlocConsumer(
                      bloc: ownerRefuseOrderBloc,
                      builder: (context, state) {
                        if (state is OwnerRefuseOrderStatesStart)
                          return Center(
                            child: SpinKitCircle(
                              color: AppTheme.primaryColor,
                              size: 40.0,
                            ),
                          );
                        else {
                          return InkWell(
                            onTap: () {
                              ownerRefuseOrderBloc.add(
                                OwnerRefuseOrderEventsStart(
                                    orderId: widget.orderId,
                                    status: "owner_refuse"),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 50,
                              width: 150,
                              child: Center(
                                child: Text(
                                  "رفض الطلب",
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
                        if (state is OwnerRefuseOrderStatesSuccess) {
                          Toast.show(
                              translator.currentLanguage == "en"
                                  ? "Done"
                                  : "تم عمل الطلب بنجاح",
                              context);
                        } else if (state is OwnerRefuseOrderStatesFailed) {
                          _handleError(state: state, context: context);
                        }
                      },
                    )
                  : Container(),
          isMyAd
              ? Container()
              : InkWell(
                  onTap: () {
                    Get.to(OtherServicesView(
                      orderId: widget.orderId,
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15)),
                    height: 50,
                    width: 100,
                    child: Center(
                      child: Text(
                        translator.currentLanguage == "en"
                            ? "Other Services"
                            : "خدمات اخري",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _orderStatus({SingleBuyingOrder order}) {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: status.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1,
                          color: status[index]['isActive']
                              ? Color(
                                  getColorHexFromStr("6DD77F"),
                                )
                              : Colors.grey,
                        ),
                      ),
                      child: Icon(
                        Icons.done,
                        size: 20,
                        color: status[index]['isActive']
                            ? Color(
                                getColorHexFromStr("6DD77F"),
                              )
                            : Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      status[index]['type'].toString(),
                      style: TextStyle(
                          color: status[index]['isActive']
                              ? Color(
                                  getColorHexFromStr("6DD77F"),
                                )
                              : Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget _orderDetails(
      {@required int orderNum,
      @required String image,
      @required String orderName,
      @required int stock,
      @required int totalPrice}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    translator.currentLanguage == "en"
                        ? "Order Number :"
                        : " رقم الطلب :",
                    style: TextStyle(
                        color: Color(getColorHexFromStr('333333')),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "$orderNum",
                    style: TextStyle(
                        color: Color(getColorHexFromStr('8B8B8B')),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ],
              ),
              SizedBox(
                height: 13,
              ),
              Row(
                children: <Widget>[
                  Text(
                    translator.currentLanguage == "en"
                        ? "Quantity :"
                        : "عدد المنتجات :",
                    style: TextStyle(
                        color: Color(getColorHexFromStr('333333')),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "$stock",
                    style: TextStyle(
                        color: Color(getColorHexFromStr('8B8B8B')),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ],
              ),
              SizedBox(
                height: 13,
              ),
              Row(
                children: <Widget>[
                  Text(
                    translator.currentLanguage == "en" ? "Cost :" : "التكلفة :",
                    style: TextStyle(
                        color: Color(getColorHexFromStr('333333')),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "$totalPrice",
                    style: TextStyle(
                        color: Color(getColorHexFromStr('8B8B8B')),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              image == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: Container(
                        height: 100,
                        width: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(image)),
                        ),
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              Text(
                "$orderName",
                style: TextStyle(
                  color: Color(getColorHexFromStr('082434')),
                  fontSize: 15,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
