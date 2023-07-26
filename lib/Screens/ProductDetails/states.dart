import 'package:flutter/material.dart';
// import 'package:orghub/Screens/Home/MostSellingAdverts/model.dart';
import 'package:orghub/Screens/ProductDetails/model.dart';

class GetSingleAdvertStates {}

class GetSingleAdvertStatesStart extends GetSingleAdvertStates {}

class GetSingleAdvertStatesSuccess extends GetSingleAdvertStates {
  SingleAdvertData advertData;
  GetSingleAdvertStatesSuccess({
    @required this.advertData,
  });
}

class GetSingleAdvertStatesFailed extends GetSingleAdvertStates {
  String msg;
  dynamic statusCode;
  int errType;
  GetSingleAdvertStatesFailed({this.msg, this.errType,this.statusCode});
}
