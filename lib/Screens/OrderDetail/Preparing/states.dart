import 'package:flutter/foundation.dart';
import 'package:orghub/Screens/OrderDetail/model.dart';

class PreparingOrderStates {}

class PreparingOrderStatesStart extends PreparingOrderStates {}

class PreparingOrderStatesSuccess extends PreparingOrderStates {
  SingleBuyingOrder singleBuyingOrder;

  PreparingOrderStatesSuccess({
    @required this.singleBuyingOrder,
  });
}

class PreparingOrderStatesFailed extends PreparingOrderStates {
  int errType;
  String msg;
  PreparingOrderStatesFailed({
    this.errType,
    this.msg,
  });
}
