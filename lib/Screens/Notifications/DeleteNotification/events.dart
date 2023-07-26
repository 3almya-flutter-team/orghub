import 'package:flutter/foundation.dart';

class NotificationsDeleteEvents {}

class NotificationsDeleteEventsStart extends NotificationsDeleteEvents {
  String notificationId;
  NotificationsDeleteEventsStart({
    @required this.notificationId,
  });
}
