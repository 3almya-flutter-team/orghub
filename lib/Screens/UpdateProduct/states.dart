class UpdateAdvertStates {}

class UpdateAdvertStatesStart extends UpdateAdvertStates {}

class UpdateAdvertStatesSuccess extends UpdateAdvertStates {}

class UpdateAdvertStatesFailed extends UpdateAdvertStates {
  int statusCode;
  int errType;
  String msg;
  UpdateAdvertStatesFailed({
    this.statusCode,
    this.errType,
    this.msg,
  });
}
