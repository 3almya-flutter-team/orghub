import 'package:flutter/material.dart';

class GetNotificationsEvents {}

class GetNotificationsEventsStart extends GetNotificationsEvents {
  int pageNum;
  GetNotificationsEventsStart({
    @required this.pageNum,
  });
}

class  GetNextNotificationsEvent extends GetNotificationsEvents{
  int pageNum;
  GetNextNotificationsEvent({this.pageNum});
}
class  GetNotificationsEventsCompleted extends GetNotificationsEvents{}
class  GetNotificationsEventsFailed extends GetNotificationsEvents{}
