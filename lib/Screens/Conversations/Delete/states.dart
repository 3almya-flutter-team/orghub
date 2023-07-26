

class ChatsDeleteStates {}

class ChatsDeleteStatesStart extends ChatsDeleteStates {}

class ChatsDeleteStatesSuccess extends ChatsDeleteStates {}

class ChatsDeleteStatesFailed extends ChatsDeleteStates {
  int errType;
  String msg;
  ChatsDeleteStatesFailed({
    this.errType,
    this.msg,
  });
}
