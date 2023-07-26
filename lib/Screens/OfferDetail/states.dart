import 'package:flutter/foundation.dart';
import 'package:orghub/Screens/OfferDetail/model.dart';

class GetSingleOfferStates {}

class GetSingleOfferStatesStart extends GetSingleOfferStates {}

class GetSingleOfferStatesSuccess extends GetSingleOfferStates {
  SingleOfferData offerData;
  GetSingleOfferStatesSuccess({
    @required this.offerData,
  });
}

class GetSingleOfferStatesFailed extends GetSingleOfferStates {
  int errType;
  String msg;
  dynamic statusCode;
  GetSingleOfferStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
