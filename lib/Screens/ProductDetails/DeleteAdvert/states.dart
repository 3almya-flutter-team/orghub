

class DeleteAdvertStates {}

class DeleteAdvertStatesStart extends DeleteAdvertStates {}

class DeleteAdvertStatesSuccess extends DeleteAdvertStates {
  
}

class DeleteAdvertStatesFailed extends DeleteAdvertStates {
  String msg;
  int errType;
  DeleteAdvertStatesFailed({this.msg, this.errType});
}
