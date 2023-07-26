import 'package:flutter/material.dart';
import 'package:orghub/Screens/Home/MostBuyingAdverts/model.dart';

class GetMostBuyingAdvertsStates {
  String msg;
  int errType;
  GetMostBuyingAdvertsStates({
    this.msg,
    this.errType,
  });
}

class GetMostBuyingAdvertsStatesStart extends GetMostBuyingAdvertsStates {}

class GetMostBuyingAdvertsStatesSuccess extends GetMostBuyingAdvertsStates {
  List<AdvertData> adverts;
  GetMostBuyingAdvertsStatesSuccess({
    @required this.adverts,
  });
}

class GetMostBuyingAdvertsStatesFailed extends GetMostBuyingAdvertsStates {
  String msg;
  int errType;
  dynamic statusCode;
  GetMostBuyingAdvertsStatesFailed({this.msg, this.errType,this.statusCode});
}
