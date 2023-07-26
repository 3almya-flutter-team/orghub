import 'package:flutter/foundation.dart';
import 'package:orghub/Screens/OrderDetail/model.dart';

class ChangeOrderStatusStates {}

class ChangeOrderStatusStatesStart extends ChangeOrderStatusStates {
  
}

class ChangeOrderStatusStatesSuccess extends ChangeOrderStatusStates {
  SingleBuyingOrder singleBuyingOrder;

  ChangeOrderStatusStatesSuccess({
    @required this.singleBuyingOrder,
  });
}

class ChangeOrderStatusStatesFailed extends ChangeOrderStatusStates {
  int errType;
  String msg;
  ChangeOrderStatusStatesFailed({
    this.errType,
    this.msg,
  });
}
