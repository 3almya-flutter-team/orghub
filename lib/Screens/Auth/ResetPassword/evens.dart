import 'package:flutter/foundation.dart';

class ResetPasswordeEvents {}

class ResetPasswordeEventsStart extends ResetPasswordeEvents {
  String phone;
  String newPassword;
  String code;
  ResetPasswordeEventsStart({
    @required this.phone,
    @required this.newPassword,
    @required this.code,
  });
}
