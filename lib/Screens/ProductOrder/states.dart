class MakeNewOrderStates {}

class MakeNewOrderStatesStart extends MakeNewOrderStates {}

class MakeNewOrderStatesSuccess extends MakeNewOrderStates {}

class MakeNewOrderStatesFailed extends MakeNewOrderStates {
  int errType;
  String msg;
  MakeNewOrderStatesFailed({
    this.errType,
    this.msg,
  });
}
