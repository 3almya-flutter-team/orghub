import 'package:flutter/material.dart';
import 'package:orghub/Screens/OrdersHistory/SellingOrders/model.dart';

class GetMySellingOrdersStates {}

class GetMySellingOrdersStatesStart extends GetMySellingOrdersStates {}

class GetMySellingOrdersStatesSuccess extends GetMySellingOrdersStates {
  List<SellingOrderDetail> mySellingOrders;
  GetMySellingOrdersStatesSuccess({
    @required this.mySellingOrders,
  });
}

class GetMySellingOrdersStatesFailed extends GetMySellingOrdersStates {
  int errType;
  dynamic statusCode;
  String msg;
  GetMySellingOrdersStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
