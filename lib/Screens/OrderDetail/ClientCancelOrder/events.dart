import 'package:flutter/foundation.dart';

class ClientCancelOrderEvents {}

class ClientCancelOrderEventsStart extends ClientCancelOrderEvents {
  int orderId;
  String status;
  ClientCancelOrderEventsStart({
    @required this.orderId,
    @required this.status,
  });
}
