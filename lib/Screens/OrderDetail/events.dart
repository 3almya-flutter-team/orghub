import 'package:flutter/material.dart';

class GetSingleBuyinOrderEvents {}

class GetSingleBuyinOrderEventsStart extends GetSingleBuyinOrderEvents {
  int orderId;
  String api;
  GetSingleBuyinOrderEventsStart({
    @required this.orderId,
    @required this.api,
  });
}

class GetSingleBuyinOrderEventsUpdated extends GetSingleBuyinOrderEvents {
  String status;

  GetSingleBuyinOrderEventsUpdated({
    @required this.status,
  });
}
