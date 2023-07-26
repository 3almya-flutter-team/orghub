import 'package:flutter/material.dart';
import 'package:location/location.dart';

class GetCurrentLocationStates {}

class GetCurrentLocationStatesStart extends GetCurrentLocationStates {}

class GetCurrentLocationStatesSuccess extends GetCurrentLocationStates {
  LocationData locationData;
  GetCurrentLocationStatesSuccess({
    @required this.locationData,
  });
}

class EnableLocationServiceStates extends GetCurrentLocationStates {}

class GetCurrentLocationStatesFailed extends GetCurrentLocationStates {
  String msg;
  GetCurrentLocationStatesFailed({
    this.msg,
  });
}
