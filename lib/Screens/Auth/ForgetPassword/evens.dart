import 'package:flutter/foundation.dart';

class SendCodeEvents {}

class SendCodeEventsStart extends SendCodeEvents {
  String phone;
  SendCodeEventsStart({
    @required this.phone,
  });
}
