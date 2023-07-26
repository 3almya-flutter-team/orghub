import 'package:flutter/foundation.dart';
import 'package:orghub/Screens/Notifications/model.dart';

class GetNotificationsStates {}

class GetNotificationsStatesStart extends GetNotificationsStates {}

class GetNotificationsStatesSuccess extends GetNotificationsStates {
  List<NotificationData> notifications;
  GetNotificationsStatesSuccess({
    @required this.notifications,
  });
}

class GetNotificationsStatesNoData extends GetNotificationsStates {}

class GetNotificationsStatesCompleted extends GetNotificationsStates {
  List<NotificationData> notifications;
  bool empty;
  bool hasReachedPageMax;
  bool hasReachedEndOfResults;
  GetNotificationsStatesCompleted(
      {this.notifications,
      this.hasReachedEndOfResults,
      this.hasReachedPageMax,
      this.empty});
}

class GetNotificationsStatesFailed extends GetNotificationsStates {
  int errType;
  String msg;
  dynamic statusCode;
  GetNotificationsStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
