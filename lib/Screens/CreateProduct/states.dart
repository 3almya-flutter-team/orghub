class CreateNewAdvertStates {}

class CreateNewAdvertStatesStart extends CreateNewAdvertStates {}

class CreateNewAdvertStatesSuccess extends CreateNewAdvertStates {}

class CreateNewAdvertStatesFailed extends CreateNewAdvertStates {
  int statusCode;
  int errType;
  String msg;
  
  CreateNewAdvertStatesFailed({
    this.statusCode,
    this.errType,
    this.msg,
  });
}
