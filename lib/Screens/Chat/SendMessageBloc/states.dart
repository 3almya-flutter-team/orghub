import 'package:flutter/cupertino.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/model.dart';

class SendMessageStates {
  String msg;
  SendMessageStates({this.msg = ""});
}

class SendMessageStatesStart extends SendMessageStates {}

class SendMessageStatesSuccess extends SendMessageStates {
  SendMessageModel message;
  SendMessageStatesSuccess({
    @required this.message,
  });
}

class SendMessageStatesFailed extends SendMessageStates {
  int errType;
  String msg;
  SendMessageStatesFailed({
    this.errType,
    this.msg,
  });
}
