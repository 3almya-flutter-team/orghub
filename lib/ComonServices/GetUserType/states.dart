import 'package:flutter/cupertino.dart';

class GetUserTypeStates {}

class GetUserTypeStatesStart extends GetUserTypeStates {}

class GetUserTypeStatesSuccess extends GetUserTypeStates {
  String type;
  GetUserTypeStatesSuccess({
    @required this.type,
  });
}

class GetUserTypeStatesFailed extends GetUserTypeStates {}
