import 'package:flutter/material.dart';
import 'package:orghub/Screens/Home/MostSellingAdverts/model.dart';

class GetCategoryAdsStates {}

class GetCategoryAdsStatesStart extends GetCategoryAdsStates {}

class GetCategoryAdsStatesSuccess extends GetCategoryAdsStates {
  List<AdvertData> adverts;
  GetCategoryAdsStatesSuccess({
    @required this.adverts,
  });
}

class GetCategoryAdsStatesFailed extends GetCategoryAdsStates {
  String msg;
  dynamic statusCode;
  int errType;
  GetCategoryAdsStatesFailed({this.msg, this.errType,this.statusCode});
}
