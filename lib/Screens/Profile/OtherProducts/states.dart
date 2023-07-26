import 'package:flutter/material.dart';
import 'package:orghub/Screens/Profile/OtherProducts/model.dart';
import 'model.dart';

class GetUserProductsStates {}

class GetUserProductsStatesStart extends GetUserProductsStates {}

class GetUserProductsStatesSuccess extends GetUserProductsStates {
  UserAdsModel userAdsModel;
  GetUserProductsStatesSuccess({
    @required this.userAdsModel,
  });
}

class GetUserProductsStatesFailed extends GetUserProductsStates {
  int errType;
  String msg;
  dynamic statusCode;
  GetUserProductsStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
