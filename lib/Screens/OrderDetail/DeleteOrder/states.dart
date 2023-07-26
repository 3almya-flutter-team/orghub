import 'package:flutter/foundation.dart';
import 'package:orghub/Screens/OrderDetail/model.dart';

class DeleteOrderStates {}

class DeleteOrderStatesStart extends DeleteOrderStates {}

class DeleteOrderStatesSuccess extends DeleteOrderStates {
  SingleBuyingOrder singleBuyingOrder;

  DeleteOrderStatesSuccess({
    @required this.singleBuyingOrder,
  });
}

class DeleteOrderStatesFailed extends DeleteOrderStates {
  int errType;
  String msg;
  DeleteOrderStatesFailed({
    this.errType,
    this.msg,
  });
}
