
class AcceptOfferStates {}

class AcceptOfferStatesStart extends AcceptOfferStates {}

class AcceptOfferStatesSuccess extends AcceptOfferStates {}

class AcceptOfferStatesFailed extends AcceptOfferStates {
  int errType;
  String msg;
  AcceptOfferStatesFailed({
    this.errType,
    this.msg,
  });
}
