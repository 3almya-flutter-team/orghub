import 'package:flutter/foundation.dart';

class MarkerEvents {}

class OnAddMarkerEvent extends MarkerEvents {
  double lat;
  double long;
  String address;
  OnAddMarkerEvent({
    @required this.address,
    @required this.lat,
    @required this.long,
  });
}

class OnRemoveMarkerEvent extends MarkerEvents {}

class OnClickMarkerEvent extends MarkerEvents {}

class OnMoveMarkerEvent extends MarkerEvents {}
