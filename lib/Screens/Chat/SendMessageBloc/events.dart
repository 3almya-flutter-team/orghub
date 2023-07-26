import 'package:flutter/foundation.dart';

class SendMessageEvents {}

class SendMessageEventsStart extends SendMessageEvents {
  int receiverId;
  dynamic message;
  String messageType;
  SendMessageEventsStart({
    @required this.receiverId,
    @required this.message,
    @required this.messageType,
  });
}
