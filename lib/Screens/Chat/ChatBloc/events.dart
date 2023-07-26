import 'package:flutter/material.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/model.dart';

class GetSingleChatEvents {}

class GetSingleChatEventsStart extends GetSingleChatEvents {
  int receiverId;
  GetSingleChatEventsStart({
    @required this.receiverId,
  });
}

class GetSingleChatEventsUpdated extends GetSingleChatEvents {
  SendMessageData mssage;
  GetSingleChatEventsUpdated({
    @required this.mssage,
  });
}
