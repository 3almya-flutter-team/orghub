import 'package:flutter/material.dart';
import 'package:orghub/Screens/Profile/model.dart';

class GetProfileState {}

class GetProfileStateStart extends GetProfileState {}

class GetProfileStateSuccess extends GetProfileState {
  ProfileModel profileModel;
  GetProfileStateSuccess({
    @required this.profileModel,
  });
}

class GetProfileStateFailed extends GetProfileState {
  String msg;
  int errType;
  GetProfileStateFailed({this.msg, this.errType});
}
