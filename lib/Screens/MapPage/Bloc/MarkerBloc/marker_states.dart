import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerStates {}

// ADD MARKER
class OnAddMarkerStateStart extends MarkerStates {}

class OnAddMarkerStateSuccess extends MarkerStates {
  Set<Marker> markers;

  OnAddMarkerStateSuccess({
    @required this.markers,
  });
}

class OnAddMarkerStateFailed extends MarkerStates {
  int errType;
  String msg;
  OnAddMarkerStateFailed({
    this.errType,
    this.msg,
  });
}

// REMOVE MARKER
class OnRemoveMarkerStateStart extends MarkerStates {}

class OnRemoveMarkerStateSuccess extends MarkerStates {}

class OnRemoveMarkerStateFailed extends MarkerStates {
  int errType;
  String msg;
  OnRemoveMarkerStateFailed({
    this.errType,
    this.msg,
  });
}

// CLICK ON MARKER
class OnClickMarkerStateStart extends MarkerStates {}

class OnClickMarkerStateSuccess extends MarkerStates {}

class OnClickMarkerStateFailed extends MarkerStates {
  int errType;
  String msg;
  OnClickMarkerStateFailed({
    this.errType,
    this.msg,
  });
}

// ON MOVE MARKER
class OnMoveMarkerStateStart extends MarkerStates {}

class OnMoveMarkerStateSuccess extends MarkerStates {}

class OnMoveMarkerStateFailed extends MarkerStates {
  int errType;
  String msg;
  OnMoveMarkerStateFailed({
    this.errType,
    this.msg,
  });
}
