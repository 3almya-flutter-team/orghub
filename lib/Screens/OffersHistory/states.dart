import 'package:flutter/material.dart';
import 'package:orghub/Screens/ProductDetails/AdOffers/model.dart';

class GetMyOffersStates {}

class GetMyOffersStatesStart extends GetMyOffersStates {}

class GetMyOffersStatesSuccess extends GetMyOffersStates {
  List<OfferData> offers;
  GetMyOffersStatesSuccess({
    @required this.offers,
  });
}

class GetMyOffersStatesFailed extends GetMyOffersStates {
  String msg;
  dynamic statusCode;
  int errType;
  GetMyOffersStatesFailed({this.msg, this.errType,this.statusCode});
}
