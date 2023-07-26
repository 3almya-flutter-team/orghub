class RateAdvertStates {}

class RateAdvertStatesStart extends RateAdvertStates {}

class RateAdvertStatesSuccess extends RateAdvertStates {}

class RateAdvertStatesFailed extends RateAdvertStates {
  String msg;
  int errType;
  RateAdvertStatesFailed({this.msg, this.errType});
}
