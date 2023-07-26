import 'package:flutter/foundation.dart';

class ChatsDeleteEvents {}

class ChatsDeleteEventsStart extends ChatsDeleteEvents {
  int chatId;
  ChatsDeleteEventsStart({
    @required this.chatId,
  });
}
