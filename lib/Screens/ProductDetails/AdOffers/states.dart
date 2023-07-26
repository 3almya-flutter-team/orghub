import 'package:flutter/material.dart';
import 'package:orghub/Screens/ProductDetails/AdOffers/model.dart';

class GetAddOffersStates {}

class GetAddOffersStatesStart extends GetAddOffersStates {}

class GetAddOffersStatesSuccess extends GetAddOffersStates {
  List<OfferData> offers;
  GetAddOffersStatesSuccess({
    @required this.offers,
  });
}

class GetAddOffersStatesFailed extends GetAddOffersStates {
  String msg;
  dynamic statusCode;
  int errType;
  GetAddOffersStatesFailed({this.msg, this.errType, this.statusCode});
}
