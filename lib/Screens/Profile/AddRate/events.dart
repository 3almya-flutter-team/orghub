import 'package:flutter/material.dart';

class RateUserEvents {}

class RateUserEvevntsStart extends RateUserEvents {
  int userId;
  double rate;
  String review;
  RateUserEvevntsStart({
    @required this.userId,
    @required this.rate,
    this.review,
  });
}