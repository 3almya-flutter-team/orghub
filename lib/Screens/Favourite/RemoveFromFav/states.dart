import 'package:flutter/foundation.dart';

class RemoveFromFavStates {}

class RemoveFromFavStatesStart extends RemoveFromFavStates {}

class RemoveFromFavStatesSuccess extends RemoveFromFavStates {
  int removedAdId;
  RemoveFromFavStatesSuccess({
    @required this.removedAdId,
  });
}

class RemoveFromFavStatesFailed extends RemoveFromFavStates {
  int errType;
  String msg;
  RemoveFromFavStatesFailed({
    this.errType,
    this.msg,
  });
}
