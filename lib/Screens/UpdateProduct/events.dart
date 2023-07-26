import 'package:flutter/material.dart';

class UpdateAdvertEvent {}

class UpdateAdvertEventStart extends UpdateAdvertEvent {
  int advertId;
  Map<String, dynamic> advertData;
  UpdateAdvertEventStart({
    @required this.advertId,
    @required this.advertData,
  });
}
