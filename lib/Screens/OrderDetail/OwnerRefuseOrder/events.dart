import 'package:flutter/foundation.dart';

class OwnerRefuseOrderEvents {}

class OwnerRefuseOrderEventsStart extends OwnerRefuseOrderEvents {
  int orderId;
  String status;
  OwnerRefuseOrderEventsStart({
    @required this.orderId,
    @required this.status,
  });
}
