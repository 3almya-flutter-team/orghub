import 'package:flutter/cupertino.dart';
import 'package:orghub/Screens/Conversations/model.dart';

class GetAllChatsStates {
  String msg;
  GetAllChatsStates({this.msg});
}

class GetAllChatsStatesStart extends GetAllChatsStates {}

class GetAllChatsStatesSuccess extends GetAllChatsStates {
  List<Conversation> conversations;
  GetAllChatsStatesSuccess({
    @required this.conversations,
  });
}

class GetAllChatsStatesNoData extends GetAllChatsStates {}

class GetAllChatsStatesCompleted extends GetAllChatsStates {
  List<Conversation> conversations;
  bool empty;
  bool hasReachedPageMax;
  bool hasReachedEndOfResults;
  GetAllChatsStatesCompleted(
      {this.conversations,
      this.hasReachedEndOfResults,
      this.hasReachedPageMax,
      this.empty});
}

class GetAllChatsStatesFailed extends GetAllChatsStates {
  int errType;
  dynamic statusCode;
  String msg;
  GetAllChatsStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
