import 'package:flutter/material.dart';
import 'package:orghub/Screens/ProductDetails/RelatedAds/model.dart';

class GetRelatedAdvertsStates {}

class GetRelatedAdvertsStatesStart extends GetRelatedAdvertsStates {}

class GetRelatedAdvertsStatesSuccess extends GetRelatedAdvertsStates {
  List<AdvertData> adverts;
  GetRelatedAdvertsStatesSuccess({
    @required this.adverts,
  });
}

class GetRelatedAdvertsStatesFailed extends GetRelatedAdvertsStates {
  String msg;
  int errType;
  GetRelatedAdvertsStatesFailed({this.msg, this.errType});
}
