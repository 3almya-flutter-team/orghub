class CheckCodeStates {}

class CheckCodeStatesStart extends CheckCodeStates {}

class CheckCodeStatesSuccess extends CheckCodeStates {}

class CheckCodeStatesFailed extends CheckCodeStates {
  int statusCode;
  int errType;
  String msg;

  CheckCodeStatesFailed({
    this.statusCode,
    this.errType,
    this.msg,
  });
}
