import 'package:flutter/foundation.dart';

class UserLoginStates {}

class UserLoginStatesStart extends UserLoginStates {}

class UserLoginStatesSuccess extends UserLoginStates {}

class UserLoginStatesFailed extends UserLoginStates {
  int statusCode;
  bool goToActivate;
  String userName;

  String msg;
  int errType;
  bool isActive;
  bool isBan;
  UserLoginStatesFailed({
    @required this.statusCode,
    @required this.msg,
    @required this.userName,
    @required this.goToActivate,
    @required this.errType,
    @required this.isActive,
    @required this.isBan,
  });
}
