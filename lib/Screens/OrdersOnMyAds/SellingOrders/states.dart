import 'package:flutter/material.dart';
import 'package:orghub/Screens/OrdersHistory/SellingOrders/model.dart';

class GetOrdersOnMySellingOrdersStates {}

class GetOrdersOnMySellingOrdersStatesStart
    extends GetOrdersOnMySellingOrdersStates {}

class GetOrdersOnMySellingOrdersStatesSuccess
    extends GetOrdersOnMySellingOrdersStates {
  List<SellingOrderDetail> mySellingOrders;
  GetOrdersOnMySellingOrdersStatesSuccess({
    @required this.mySellingOrders,
  });
}

class GetOrdersOnMySellingOrdersStatesFailed
    extends GetOrdersOnMySellingOrdersStates {
  int errType;
  dynamic statusCode;
  String msg;
  GetOrdersOnMySellingOrdersStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
