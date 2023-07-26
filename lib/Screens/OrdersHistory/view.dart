import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/OrderDetail/view.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Screens/OrdersHistory/BuyingOrders/bloc.dart';
import 'package:orghub/Screens/OrdersHistory/BuyingOrders/events.dart';
import 'package:orghub/Screens/OrdersHistory/BuyingOrders/states.dart';
import 'package:orghub/Screens/OrdersHistory/SellingOrders/bloc.dart';
import 'package:orghub/Screens/OrdersHistory/SellingOrders/events.dart';
import 'package:orghub/Screens/OrdersHistory/SellingOrders/states.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory>
    with TickerProviderStateMixin {
  TabController _tabController;

  GetMyOrdersBloc getMyOrdersBloc =
      kiwi.KiwiContainer().resolve<GetMyOrdersBloc>();
  GetMySellingOrdersBloc getMySellingOrdersBloc =
      kiwi.KiwiContainer().resolve<GetMySellingOrdersBloc>();
  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2);
    getMyOrdersBloc.add(GetMyOrdersEventsStart());
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    getMyOrdersBloc.close();
    getMySellingOrdersBloc.close();
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
        appBar: AppBar(
          bottom: PreferredSize(
            child: TabBar(
                controller: _tabController,
                indicatorColor: Color(getColorHexFromStr('D1372E')),
                onTap: (index) {
                  setState(() {
                    if (index == 0) {
                      getMyOrdersBloc.add(GetMyOrdersEventsStart());
                    } else {
                      getMySellingOrdersBloc
                          .add(GetMySellingOrdersEventsStart());
                    }
                  });
                },
                // indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Color(getColorHexFromStr('D1372E')),
                unselectedLabelColor: Color(getColorHexFromStr('C9C9C9')),
                labelStyle: TextStyle(fontSize: 15, fontFamily: "NeoSans"),
                tabs: [
                  Tab(
                    text: translator.currentLanguage == 'en'
                        ? "Buying Orders"
                        : "طلبات الشراء",
                  ),
                  Tab(
                    text: translator.currentLanguage == 'en'
                        ? "Selling Orders"
                        : "طلبات البيع",
                  ),
                ]),
            preferredSize: Size.fromHeight(40),
          ),
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
              }),
          title: Text(
            translator.currentLanguage == 'en'
                ? "Orders History"
                : "سجل الطلبات",
            style: TextStyle(
                color: AppTheme.appBarTextColor,
                fontSize: 20,
                fontFamily: "NeoSans",
                fontWeight: FontWeight.w900),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  BlocBuilder(
                      bloc: getMyOrdersBloc,
                      builder: (context, state) {
                        if (state is GetMyOrdersStatesStart) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SpinKitThreeBounce(
                              color: AppTheme.primaryColor,
                              size: 30,
                            ),
                          );
                        } else if (state is GetMyOrdersStatesSuccess) {
                          return state.myOrders.isEmpty
                              ? Center(
                                  child: Text(translator.currentLanguage == 'en'
                                      ? "Empty"
                                      : "لا يوجد"),
                                )
                              : ListView.builder(
                                  itemCount: state.myOrders.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsOrder(
                                              orderId: state.myOrders[index].id,
                                              api: "orders",
                                            ),
                                          ),
                                        );
                                      },
                                      child: _card(
                                        date: state.myOrders[index].createdAt,
                                        qun: state.myOrders[index].bill.qty,
                                        type: state.myOrders[index].bill
                                            .classification,
                                        image: state.myOrders[index].bill.image,
                                        specification: state
                                            .myOrders[index].bill.specification,
                                        coast: state.myOrders[index].bill.price,
                                        orderStatus: state
                                            .myOrders[index].transOrderStatus,
                                        orderName:
                                            state.myOrders[index].bill.name,
                                      ),
                                    );
                                  });
                        } else if (state is GetMyOrdersStatesFailed) {
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

                  //------------
                  BlocBuilder(
                      bloc: getMySellingOrdersBloc,
                      builder: (context, state) {
                        if (state is GetMySellingOrdersStatesStart) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SpinKitThreeBounce(
                              color: AppTheme.primaryColor,
                              size: 30,
                            ),
                          );
                        } else if (state is GetMySellingOrdersStatesSuccess) {
                          return state.mySellingOrders.isEmpty
                              ? Center(
                                  child: Text(translator.currentLanguage == 'en'
                                      ? "Empty"
                                      : "لا يوجد"),
                                )
                              : ListView.builder(
                                  itemCount: state.mySellingOrders.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsOrder(
                                              orderId: state
                                                  .mySellingOrders[index].id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: _card(
                                        date: state
                                            .mySellingOrders[index].createdAt,
                                        qun: state
                                            .mySellingOrders[index].bill.qty,
                                        type: state.mySellingOrders[index].bill
                                            .classification,
                                        image: state
                                            .mySellingOrders[index].bill.image,
                                        specification: state
                                            .mySellingOrders[index]
                                            .bill
                                            .specification,
                                        coast: state
                                            .mySellingOrders[index].bill.price,
                                        orderStatus: state
                                            .mySellingOrders[index]
                                            .transOrderStatus,
                                        orderName: state
                                            .mySellingOrders[index].bill.name,
                                      ),
                                    );
                                  });
                        } else if (state is GetMySellingOrdersStatesFailed) {
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
                  // ListView.builder(
                  //     itemCount: 5,
                  //     itemBuilder: (context, index) {
                  //       return _card(
                  //           date: "1/9/2020",
                  //           image: "",
                  //           qun: "٣",
                  //           type: "جديد",
                  //           specification: "اوروبي",
                  //           coast: "3939",
                  //           orderStatus: "جاري التجهيز",
                  //           orderName: "موبايل");
                  //     })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _card(
      {String date,
      qun,
      image,
      type,
      specification,
      coast,
      orderStatus,
      orderName}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    orderName,
                    style: TextStyle(
                      color: Color(getColorHexFromStr('082434')),
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        translator.currentLanguage == 'en'
                            ? "Advert Date :"
                            : "تاريخ الاعلان :",
                        style: TextStyle(
                          color: Color(getColorHexFromStr('333333')),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      AutoSizeText(
                        date,
                        maxLines: 1,
                        style: TextStyle(
                            color: Color(getColorHexFromStr('949494')),
                            // fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        translator.currentLanguage == 'en'
                            ? "Quantity"
                            : "الكمية :",
                        style: TextStyle(
                            color: Color(getColorHexFromStr('333333')),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        qun.toString(),
                        style: TextStyle(
                            color: Color(getColorHexFromStr('949494')),
                            // fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        translator.currentLanguage == 'en'
                            ? "Type :"
                            : "النوع :",
                        style: TextStyle(
                            color: Color(getColorHexFromStr('333333')),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        type,
                        style: TextStyle(
                            color: Color(getColorHexFromStr('949494')),
                            // fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        translator.currentLanguage == 'en'
                            ? "Classifications"
                            : "المواصفات :",
                        style: TextStyle(
                            color: Color(getColorHexFromStr('333333')),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        specification,
                        style: TextStyle(
                            color: Color(getColorHexFromStr('949494')),
                            // fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        translator.currentLanguage == 'en'
                            ? "Cost :"
                            : "التكلفة :",
                        style: TextStyle(
                            color: Color(getColorHexFromStr('333333')),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        coast,
                        style: TextStyle(
                            color: Color(getColorHexFromStr('70DB71')),
                            // fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        translator.currentLanguage == 'en'
                            ? "Order Status :"
                            : "حالة الطلب :",
                        style: TextStyle(
                            color: Color(getColorHexFromStr('333333')),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        orderStatus,
                        style: TextStyle(
                            color: Color(getColorHexFromStr('70DB71')),
                            // fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
