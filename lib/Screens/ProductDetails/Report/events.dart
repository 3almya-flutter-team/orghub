import 'package:flutter/material.dart';

class SendReportEvents {}

class SendReportEventsStart extends SendReportEvents {
  int reasonId;
  int advertId;
  String msg;
  SendReportEventsStart({
    @required this.reasonId,
    @required this.advertId,
    @required this.msg,
  });
}
