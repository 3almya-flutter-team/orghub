import 'package:flutter/foundation.dart';

class PreparingOrderEvents {}

class PreparingOrderEventsStart extends PreparingOrderEvents {
  int orderId;
  String status;
  PreparingOrderEventsStart({
    @required this.orderId,
    @required this.status,
  });
}
