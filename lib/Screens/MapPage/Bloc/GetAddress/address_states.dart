import 'package:flutter/foundation.dart';

class GetAddressStates {}

// ADD GetAddress
class GetAddressStateStart extends GetAddressStates {}

class GetAddressStateSuccess extends GetAddressStates {
  String address;
  double lat;
  double long;

  GetAddressStateSuccess({
    @required this.address,
    @required this.lat,
    @required this.long,
  });
}

class GetAddressStateFailed extends GetAddressStates {
  int errType;
  String msg;
  GetAddressStateFailed({
    this.errType,
    this.msg,
  });
}

