import 'package:flutter/foundation.dart';

class UpdatePasswordEvents {}

class UpdatePasswordEventsStart extends UpdatePasswordEvents {
  @required
  String oldPass;
  @required
  String newPass;
  UpdatePasswordEventsStart({
    this.newPass,
    this.oldPass,
  });
}
