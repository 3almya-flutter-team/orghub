import 'package:flutter/cupertino.dart';
import 'package:orghub/Screens/MyComments/model.dart';

class GetAllCommentsStates {}

class GetAllCommentsStatesStart extends GetAllCommentsStates {}

class GetAllCommentsStatesSuccess extends GetAllCommentsStates {
  List<CommentData> myComments;
  GetAllCommentsStatesSuccess({
    @required this.myComments,
  });
}

class GetAllCommentsStatesFailed extends GetAllCommentsStates {
  int errType;
  String msg;
  dynamic statusCode;
  GetAllCommentsStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
