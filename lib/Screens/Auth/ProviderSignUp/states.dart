class ProviderRegisterStates {}

class ProviderRegisterStateStart extends ProviderRegisterStates {
  // start loader
}

class ProviderRegisterStateFailed extends ProviderRegisterStates {
  // stop loader
  // show error message
  final int errType;
  final int statusCode;
  
  final String msg;

  ProviderRegisterStateFailed({this.errType, this.statusCode, this.msg});
}

class ProviderRegisterStateSuccess extends ProviderRegisterStates {
  // stop loader
  // Go to home page
}
