import 'package:flutter/foundation.dart';

class ChangeOrderStatusEvents {}

class ChangeOrderStatusEventsStart extends ChangeOrderStatusEvents {
  int orderId;
  String status;
  ChangeOrderStatusEventsStart({
    @required this.orderId,
    @required this.status,
  });
}
