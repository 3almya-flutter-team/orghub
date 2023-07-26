import 'package:flutter/material.dart';
import 'package:orghub/Screens/UpdateUserProfile/model.dart';

class GetUserProfileState {}

class GetUserProfileStateStart extends GetUserProfileState {}

class GetUserProfileStateSuccess extends GetUserProfileState {
  UserProfileModel userProfileModel;
  GetUserProfileStateSuccess({
    @required this.userProfileModel,
  });
}

class GetUserProfileStateFailed extends GetUserProfileState {
  String msg;
  dynamic statusCode;
  int errType;
  GetUserProfileStateFailed({this.msg, this.errType,this.statusCode});
}
