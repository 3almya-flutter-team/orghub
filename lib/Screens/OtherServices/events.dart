import 'package:flutter/foundation.dart';

class SelectOtherServiceEvent {}

class SelectOtherServiceEventStart extends SelectOtherServiceEvent {
  String service;
  int orderId;
  SelectOtherServiceEventStart({
    @required this.service,
    @required this.orderId,
  });
}
