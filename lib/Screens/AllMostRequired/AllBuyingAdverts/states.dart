import 'package:flutter/material.dart';
import 'package:orghub/Screens/AllMostRequired/AllBuyingAdverts/model.dart';

class GetAllBuyingAdvertsStates {}

class GetAllBuyingAdvertsStatesStart extends GetAllBuyingAdvertsStates {}

class GetAllBuyingAdvertsStatesSuccess extends GetAllBuyingAdvertsStates {
  List<AdvertData> adverts;
  GetAllBuyingAdvertsStatesSuccess({
    @required this.adverts,
  });
}

class GetAllBuyingAdvertsStatesNoData extends GetAllBuyingAdvertsStates {}

class GetAllBuyingAdvertsStatesCompleted extends GetAllBuyingAdvertsStates {
  List<AdvertData> adverts;
  bool empty;
  bool hasReachedPageMax;
  bool hasReachedEndOfResults;
  GetAllBuyingAdvertsStatesCompleted(
      {this.adverts,
      this.hasReachedEndOfResults,
      this.hasReachedPageMax,
      this.empty});
}

class GetAllBuyingAdvertsStatesFailed extends GetAllBuyingAdvertsStates {
  String msg;
  dynamic statusCode;
  int errType;
  GetAllBuyingAdvertsStatesFailed({this.msg, this.errType,this.statusCode});
}
