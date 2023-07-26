import 'package:flutter/cupertino.dart';

class MakeNewOrderEvents {}

class MakeNewOrderEventsStart extends MakeNewOrderEvents {
  Map<String,dynamic> orderData;
  MakeNewOrderEventsStart({
    @required this.orderData,
  });
}
