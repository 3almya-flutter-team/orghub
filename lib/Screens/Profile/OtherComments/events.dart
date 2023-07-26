import 'package:flutter/foundation.dart';

class GetUserCommentsEvents {}

class GetUserCommentsEventsStart extends GetUserCommentsEvents {
  int userId;
  GetUserCommentsEventsStart({
   @required  this.userId,
  });
}
