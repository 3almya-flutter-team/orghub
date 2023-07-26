class ContactStates {}

class ContactStatesStart extends ContactStates {}

class ContactStatesSuccess extends ContactStates {}

class ContactStatesFailed extends ContactStates {
  int errType;
  String msg;
  ContactStatesFailed({
    this.errType,
    this.msg,
  });
}
