import 'package:flutter/material.dart';
import 'package:orghub/Screens/ProductDetails/Report/ReasonsBloc/model.dart';

class GetReportReasonsStates {}

class GetReportReasonsStatesStart extends GetReportReasonsStates {}

class GetReportReasonsStatesSuccess extends GetReportReasonsStates {
  List<ReasonData> reasons;
  GetReportReasonsStatesSuccess({
    @required this.reasons,
  });
}

class GetReportReasonsStatesFailed extends GetReportReasonsStates {
  int errType;
  dynamic statusCode;
  String msg;
  GetReportReasonsStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
