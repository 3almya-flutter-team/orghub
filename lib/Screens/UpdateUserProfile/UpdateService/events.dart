

class UserProfileUpdateEvents {}

class UserProfileUpdateEventStart extends UserProfileUpdateEvents {
  Map<String,dynamic> userData;
  UserProfileUpdateEventStart({this.userData});
}

class UserProfileUpdateEventFailed extends UserProfileUpdateEvents {}

class UserProfileUpdateEventSuccess extends UserProfileUpdateEvents {}