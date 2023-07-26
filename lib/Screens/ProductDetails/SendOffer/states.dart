class SendOfferStates {}

class SendOfferStatesStart extends SendOfferStates {}

class SendOfferStatesSuccess extends SendOfferStates {}

class SendOfferStatesFailed extends SendOfferStates {
  int errType;
  String msg;
  SendOfferStatesFailed({
    this.errType,
    this.msg,
  });
}
