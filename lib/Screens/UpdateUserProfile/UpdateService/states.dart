class UserProfileUpdateStates {}

class UserProfileUpdateStateStart extends UserProfileUpdateStates {
  // start loader
}

class UserProfileUpdateStateFailed extends UserProfileUpdateStates {
  // stop loader
  // show error message
  final int errType;
  final int statusCode;
  
  final String msg;

  UserProfileUpdateStateFailed({this.errType, this.statusCode, this.msg});
}

class UserProfileUpdateStateSuccess extends UserProfileUpdateStates {
  // stop loader
  // Go to home page
}
