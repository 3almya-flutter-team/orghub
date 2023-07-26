import 'package:flutter/foundation.dart';
import 'package:orghub/Screens/OrderDetail/model.dart';

class GetSingleBuyinOrderStates {}

class GetSingleBuyinOrderStatesStart extends GetSingleBuyinOrderStates {}

class GetSingleBuyinOrderStatesSuccess extends GetSingleBuyinOrderStates {
  SingleBuyingOrder singleBuyingOrder;
  GetSingleBuyinOrderStatesSuccess({
    @required this.singleBuyingOrder,
  });
}

// class GetSingleBuyinOrderStatesUpdated extends GetSingleBuyinOrderStates {
//   SingleBuyingOrder singleBuyingOrder;
//   GetSingleBuyinOrderStatesUpdated({
//     @required this.singleBuyingOrder,
//   });
// }

class GetSingleBuyinOrderStatesFailed extends GetSingleBuyinOrderStates {
  int errType;
  String msg;
  dynamic statusCode;
  GetSingleBuyinOrderStatesFailed({
    @required this.errType,
    @required this.statusCode,
    @required this.msg,
  });
}
