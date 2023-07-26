import 'package:flutter/material.dart';
import 'package:orghub/Screens/OrdersHistory/BuyingOrders/model.dart';

class GetOrdersOnMyAdsStates {}

class GetOrdersOnMyAdsStatesStart extends GetOrdersOnMyAdsStates {}

class GetOrdersOnMyAdsStatesSuccess extends GetOrdersOnMyAdsStates {
  List<OrderDetail> myOrders;
  GetOrdersOnMyAdsStatesSuccess({
    @required this.myOrders,
  });
}

class GetOrdersOnMyAdsStatesFailed extends GetOrdersOnMyAdsStates {
  int errType;
  String msg;
  dynamic statusCode;
  GetOrdersOnMyAdsStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
