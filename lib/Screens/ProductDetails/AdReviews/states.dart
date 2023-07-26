import 'package:flutter/material.dart';
import 'package:orghub/Screens/ProductDetails/AdReviews/model.dart';

class GetSomeAddReviewStates {}

class GetSomeAddReviewStatesStart extends GetSomeAddReviewStates {}

class GetSomeAddReviewStatesSuccess extends GetSomeAddReviewStates {
  List<ReviewData> addReviews;
  GetSomeAddReviewStatesSuccess({
    @required this.addReviews,
  });
}

class GetSomeAddReviewStatesFailed extends GetSomeAddReviewStates {
  String msg;
  int errType;
  GetSomeAddReviewStatesFailed({this.msg, this.errType});
}
