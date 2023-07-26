import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:orghub/Screens/MapPage/Bloc/map_events.dart';
import 'package:orghub/Screens/MapPage/Bloc/map_states.dart';

// import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:permission_handler/permission_handler.dart' as pmHandler;

class MapBloc extends Bloc<MapEvents, MapStates> {
  MapBloc() : super(MapStates(userCurrentAddress: null));

  @override
  Stream<MapStates> mapEventToState(MapEvents event) async* {
    if (event is MapEventsStart) {
      yield MapStatesStart();
      if (await pmHandler.Permission.location.request().isGranted) {
        print("keda tamam walla ayh");
        // Either the permission was already granted before or the user just granted it.
        UserCurrentAddress userCurrentAddress = await _getUserLocation();
        yield MapStatesSuccess(userCurrentAddress: userCurrentAddress);
        // SEND USER LOCATION TO MAP PAGE
      } else {
        print("failed map ya raies");
        yield MapStatesFailed();
      }
    }
  }

  // ! TO GET THE USERS LOCATION
  Future<UserCurrentAddress> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    print(
        "the latitude is: ${position.longitude} and th longitude is: ${position.longitude} ");

    String address = placemarks[0].name;
    print("initial position is : $address");

    return UserCurrentAddress(
        address: address ?? "",
        lat: position.latitude,
        long: position.longitude);
  }
}

class UserCurrentAddress {
  double lat;
  double long;
  String address;
  UserCurrentAddress({
    @required this.lat,
    @required this.long,
    @required this.address,
  });
}
