import 'package:flutter/material.dart';
// import 'package:orghub/Screens/Chat/ChatBloc/model.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/model.dart';

class GetSingleChatStates {
  String msg;
  GetSingleChatStates({this.msg = ""});
}

class GetSingleChatStatesStart extends GetSingleChatStates {}

class ScrollToEndState extends GetSingleChatStates {}

class GetSingleChatStatesSucess extends GetSingleChatStates {
  List<SendMessageData> messages;
  int chatId;
  GetSingleChatStatesSucess({
    @required this.messages,
    @required this.chatId,
  });
}

class GetSingleChatStatesFailed extends GetSingleChatStates {
  int errType;
  String msg;
  dynamic statusCode;
  GetSingleChatStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
