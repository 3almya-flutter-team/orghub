import 'package:flutter/cupertino.dart';
import 'package:orghub/Screens/Profile/OtherComments/model.dart';

class GetUserCommentsStates {}

class GetUserCommentsStatesStart extends GetUserCommentsStates {}

class GetUserCommentsStatesSuccess extends GetUserCommentsStates {
  List<CommentData> userComments;
  GetUserCommentsStatesSuccess({
    @required this.userComments,
  });
}

class GetUserCommentsStatesFailed extends GetUserCommentsStates {
  int errType;
  String msg;
  dynamic statusCode;
  GetUserCommentsStatesFailed({
    this.errType,
    this.msg,
    this.statusCode,
  });
}
