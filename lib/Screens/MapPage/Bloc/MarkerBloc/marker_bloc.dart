import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:orghub/Screens/MapPage/Bloc/MarkerBloc/marker_events.dart';
import 'package:orghub/Screens/MapPage/Bloc/MarkerBloc/marker_states.dart';


class AddMarkerToMapBloc extends Bloc<MarkerEvents, MarkerStates> {
  AddMarkerToMapBloc() : super(MarkerStates());

  @override
  Stream<MarkerStates> mapEventToState(MarkerEvents event) async* {
    if (event is OnAddMarkerEvent) {
      yield OnAddMarkerStateStart();
      Set<Marker> markers =
          _addMarker(LatLng(event.lat, event.long), event.address);
      yield OnAddMarkerStateSuccess(markers: markers);
    }
  }

  // ! ADD A MARKER ON THE MAB
  Set<Marker> _addMarker(LatLng location, String address) {
    Set<Marker> _markers = {};
    _markers.add(Marker(
        markerId: MarkerId("${location.latitude.toString()}-${DateTime.now()}"),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "go here"),
        icon: BitmapDescriptor.defaultMarker));

    return _markers;
  }
}
