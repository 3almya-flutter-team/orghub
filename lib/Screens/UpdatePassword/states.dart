class UpdatePasswordStates {}

class UpdatePasswordStatesStart extends UpdatePasswordStates {}

class UpdatePasswordStatesSuccess extends UpdatePasswordStates {}

class UpdatePasswordStatesFailed extends UpdatePasswordStates {
  int errType;
  String msg;
  UpdatePasswordStatesFailed({
    this.errType,
    this.msg,
  });
}
