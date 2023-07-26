import 'package:flutter/material.dart';

class RateAdvertEvents {}

class RateAdvertEvevntsStart extends RateAdvertEvents {
  int advertId;
  double rate;
  String review;
  RateAdvertEvevntsStart({
    @required this.advertId,
    @required this.rate,
    this.review,
  });
}