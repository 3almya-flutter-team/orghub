import 'package:flutter/material.dart';
import 'package:orghub/Screens/Auth/SignIn/view.dart';

class UserLoginEvents {}

class UserLoginEventsStart extends UserLoginEvents {
  UserLoginData userLoginData;
  UserLoginEventsStart({
    @required this.userLoginData,
  });
}

class UserLoginEventsSuccess extends UserLoginEvents {}

class UserLoginEventsFailed extends UserLoginEvents {
  int statusCode;
  String msg;
  int errType;
  UserLoginEventsFailed({
    @required this.statusCode,
    @required this.msg,
    @required this.errType,
  });
}
