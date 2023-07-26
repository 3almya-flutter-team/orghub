class RateUserStates {}

class RateUserStatesStart extends RateUserStates {}

class RateUserStatesSuccess extends RateUserStates {}

class RateUserStatesFailed extends RateUserStates {
  String msg;
  dynamic statusCode;
  int errType;
  RateUserStatesFailed({this.msg, this.errType,this.statusCode});
}
