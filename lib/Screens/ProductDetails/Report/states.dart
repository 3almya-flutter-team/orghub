class SendReportStates {}

class SendReportStatesStart extends SendReportStates {}

class SendReportStatesSuccess extends SendReportStates {}

class SendReportStatesFailed extends SendReportStates {
  int errType;
  String msg;
  SendReportStatesFailed({
    this.errType,
    this.msg,
  });
}
