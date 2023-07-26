
class DeleteImageStates {}

class DeleteImageStatesStart extends DeleteImageStates {}
class DeleteImageStatesSuccess extends DeleteImageStates {}
class DeleteImageStatesFailed extends DeleteImageStates {
   int errType;
  String msg;
  DeleteImageStatesFailed({
    this.errType,
    this.msg,
  });
}
