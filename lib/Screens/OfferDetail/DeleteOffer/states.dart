
class DeleteOfferStates {}

class DeleteOfferStatesStart extends DeleteOfferStates {}

class DeleteOfferStatesSuccess extends DeleteOfferStates {}

class DeleteOfferStatesFailed extends DeleteOfferStates {
  int errType;
  String msg;
  DeleteOfferStatesFailed({
    this.errType,
    this.msg,
  });
}
