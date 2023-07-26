import 'package:flutter/cupertino.dart';
import 'package:orghub/Screens/AppInfo/About/model.dart';

class GetAboutDataStates {}

class GetAboutDataStatesStart extends GetAboutDataStates {}

class GetAboutDataStatesSuccess extends GetAboutDataStates {
  AboutData aboutData;
  GetAboutDataStatesSuccess({
    @required this.aboutData,
  });
}

class GetAboutDataStatesFailed extends GetAboutDataStates {
  int errType;
  String msg;
  GetAboutDataStatesFailed({
    this.errType,
    this.msg,
  });
}
