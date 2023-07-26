class ResetPasswordeStates {}

class ResetPasswordeStatesStart extends ResetPasswordeStates {}

class ResetPasswordeStatesSuccess extends ResetPasswordeStates {}

class ResetPasswordeStatesFailed extends ResetPasswordeStates {
  int statusCode;
  
  String msg;
  int errType;
  
  ResetPasswordeStatesFailed({
    this.statusCode,
    this.msg,
    
    this.errType,
    
  });
}
