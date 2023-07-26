import 'package:flutter/material.dart';

class CreateNewAdvertEvent {}

class CreateNewAdvertEventStart extends CreateNewAdvertEvent {
  Map<String, dynamic> advertData;
  CreateNewAdvertEventStart({
    @required this.advertData,
  });
}
