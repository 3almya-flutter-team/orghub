import 'package:flutter/material.dart';
import 'package:orghub/Screens/OrdersHistory/BuyingOrders/model.dart';

class GetMyOrdersStates {}

class GetMyOrdersStatesStart extends GetMyOrdersStates {}

class GetMyOrdersStatesSuccess extends GetMyOrdersStates {
  List<OrderDetail> myOrders;
  GetMyOrdersStatesSuccess({
    @required this.myOrders,
  });
}

class GetMyOrdersStatesFailed extends GetMyOrdersStates {
  int errType;
  dynamic statusCode;
  String msg;
  GetMyOrdersStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
