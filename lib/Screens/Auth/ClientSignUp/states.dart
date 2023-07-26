class ClientRegisterStates {}

class  ClientRegisterStateStart extends  ClientRegisterStates {
  // start loader
}

class  ClientRegisterStateFailed extends  ClientRegisterStates {
  // stop loader
  // show error message
  final int errType;
  final int statusCode;
  
  final String msg;

   ClientRegisterStateFailed({this.errType, this.statusCode, this.msg});
}

class  ClientRegisterStateSuccess extends  ClientRegisterStates {
  // stop loader
  // Go to home page
}
