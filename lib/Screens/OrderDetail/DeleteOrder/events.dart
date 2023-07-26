import 'package:flutter/foundation.dart';

class DeleteOrderEvents {}

class DeleteOrderEventsStart extends DeleteOrderEvents {
  int orderId;
  String status;
  DeleteOrderEventsStart({
    @required this.orderId,
    @required this.status,
  });
}
