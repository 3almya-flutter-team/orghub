import 'package:flutter/foundation.dart';
import 'package:orghub/Screens/MapPage/Bloc/map_bloc.dart';

class MapStates {
  UserCurrentAddress userCurrentAddress;
  MapStates({
    @required this.userCurrentAddress,
  });
}

class MapStatesStart extends MapStates {}

class MapStatesSuccess extends MapStates {
  UserCurrentAddress userCurrentAddress;
  MapStatesSuccess({
    @required this.userCurrentAddress,
  }) : super(userCurrentAddress: userCurrentAddress);
}

class MapStatesFailed extends MapStates {
  int errType;
  String msg;
  MapStatesFailed({
    this.errType,
    this.msg,
  });
}
