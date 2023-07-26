import 'package:flutter/material.dart';
import 'package:orghub/Screens/Home/MostSellingAdverts/model.dart';

class GetMostSellingAdvertsStates {
  String msg;
  int errType;
  GetMostSellingAdvertsStates({this.msg, this.errType});
}

class GetMostSellingAdvertsStatesStart extends GetMostSellingAdvertsStates {}

class GetMostSellingAdvertsStatesSuccess extends GetMostSellingAdvertsStates {
  List<AdvertData> adverts;
  GetMostSellingAdvertsStatesSuccess({
    @required this.adverts,
  });
}

class GetMostSellingAdvertsStatesFailed extends GetMostSellingAdvertsStates {
  String msg;
  int errType;
  dynamic statusCode;
  GetMostSellingAdvertsStatesFailed({this.msg, this.errType,this.statusCode});
}
