class CompanyUpdateStates {}

class CompanyUpdateStateStart extends CompanyUpdateStates {
  // start loader
}

class CompanyUpdateStateFailed extends CompanyUpdateStates {
  // stop loader
  // show error message
  final int errType;
  final int statusCode;
  
  final String msg;

  CompanyUpdateStateFailed({this.errType, this.statusCode, this.msg});
}

class CompanyUpdateStateSuccess extends CompanyUpdateStates {
  // stop loader
  // Go to home page
}
