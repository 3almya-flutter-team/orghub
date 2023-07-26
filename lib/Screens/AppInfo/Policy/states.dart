import 'package:flutter/cupertino.dart';
import 'package:orghub/Screens/AppInfo/Policy/model.dart';

class GetPolicyDataStates {}

class GetPolicyDataStatesStart extends GetPolicyDataStates {}

class GetPolicyDataStatesSuccess extends GetPolicyDataStates {
  PolicyData policyData;
  GetPolicyDataStatesSuccess({
    @required this.policyData,
  });
}

class GetPolicyDataStatesFailed extends GetPolicyDataStates {
  int errType;
  dynamic statusCode;
  String msg;
  GetPolicyDataStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
