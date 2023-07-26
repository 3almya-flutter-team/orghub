class SendCodeStates {}

class SendCodeStatesStart extends SendCodeStates {}

class SendCodeStatesSuccess extends SendCodeStates {}

class SendCodeStatesFailed extends SendCodeStates {
  int statusCode;
  bool goToActivate;
  String msg;
  int errType;
  bool isActive;
  bool isBan;
  SendCodeStatesFailed({
    this.statusCode,
    this.msg,
    this.goToActivate,
    this.errType,
    this.isActive,
    this.isBan,
  });
}
