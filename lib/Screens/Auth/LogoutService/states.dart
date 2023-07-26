class LogoutStates {}

class LogoutStateStart extends LogoutStates {}

class LogoutStateSuccess extends LogoutStates {}

class LogoutStateFailed extends LogoutStates {
  int errType;
  String msg;
  LogoutStateFailed({
    this.errType,
    this.msg,
  });
}
