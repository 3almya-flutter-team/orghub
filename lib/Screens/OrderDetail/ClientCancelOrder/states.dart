import 'package:flutter/foundation.dart';
import 'package:orghub/Screens/OrderDetail/model.dart';

class ClientCancelOrderStates {}

class ClientCancelOrderStatesStart extends ClientCancelOrderStates {}

class ClientCancelOrderStatesSuccess extends ClientCancelOrderStates {
  SingleBuyingOrder singleBuyingOrder;

  ClientCancelOrderStatesSuccess({
    @required this.singleBuyingOrder,
  });
}

class ClientCancelOrderStatesFailed extends ClientCancelOrderStates {
  int errType;
  String msg;
  ClientCancelOrderStatesFailed({
    this.errType,
    this.msg,
  });
}
