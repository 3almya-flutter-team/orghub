import 'dart:async';

import 'package:orghub/Screens/Chat/SendMessageBloc/model.dart';

/// Class to store runtime global settings.
class AppGlobals {
  factory AppGlobals() => instance;

  AppGlobals._();

  /// Singleton instance.
  static final AppGlobals instance = AppGlobals._();

  StreamController<SendMessageData> controller = StreamController.broadcast();



  void closeStream() {
    controller.close();
  }
}