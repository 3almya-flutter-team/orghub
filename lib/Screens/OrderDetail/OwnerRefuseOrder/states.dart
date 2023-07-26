import 'package:flutter/foundation.dart';
import 'package:orghub/Screens/OrderDetail/model.dart';

class OwnerRefuseOrderStates {}

class OwnerRefuseOrderStatesStart extends OwnerRefuseOrderStates {}

class OwnerRefuseOrderStatesSuccess extends OwnerRefuseOrderStates {
  SingleBuyingOrder singleBuyingOrder;

  OwnerRefuseOrderStatesSuccess({
    @required this.singleBuyingOrder,
  });
}

class OwnerRefuseOrderStatesFailed extends OwnerRefuseOrderStates {
  int errType;
  String msg;
  OwnerRefuseOrderStatesFailed({
    this.errType,
    this.msg,
  });
}
