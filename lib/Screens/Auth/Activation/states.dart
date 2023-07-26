class ActivateAccountStates {}

class ActivateAccountStatesStart extends ActivateAccountStates {}

class ActivateAccountStatesSuccess extends ActivateAccountStates {}

class ActivateAccountStatesFailed extends ActivateAccountStates {
  int statusCode;
  int errType;
  String msg;

  ActivateAccountStatesFailed({
    this.statusCode,
    this.errType,
    this.msg,
  });
}
