import 'package:flutter/cupertino.dart';
import 'package:orghub/Screens/OtherProfileComments/model.dart';

class GetAllCompanyCommentsStates {}

class GetAllCompanyCommentsStatesStart extends GetAllCompanyCommentsStates {}

class GetAllCompanyCommentsStatesSuccess extends GetAllCompanyCommentsStates {
  List<CommentData> allComments;
  GetAllCompanyCommentsStatesSuccess({
    @required this.allComments,
  });
}

class GetAllCompanyCommentsStatesFailed extends GetAllCompanyCommentsStates {
  int errType;
  String msg;
  dynamic statusCode;
  GetAllCompanyCommentsStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
