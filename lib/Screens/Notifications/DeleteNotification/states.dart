

class NotificationsDeleteStates {}

class NotificationsDeleteStatesStart extends NotificationsDeleteStates {}

class NotificationsDeleteStatesSuccess extends NotificationsDeleteStates {}

class NotificationsDeleteStatesFailed extends NotificationsDeleteStates {
  int errType;
  String msg;
  NotificationsDeleteStatesFailed({
    this.errType,
    this.msg,
  });
}
