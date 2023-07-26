import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:orghub/ComonServices/GetCurrentLocation/events.dart';
import 'package:orghub/ComonServices/GetCurrentLocation/states.dart';
import 'package:orghub/Helpers/prefs.dart';

class GetCurrentLocationBloc
    extends Bloc<GetCurrentLocationEvents, GetCurrentLocationStates> {
  GetCurrentLocationBloc() : super(GetCurrentLocationStates());
  Location location = Location();

  @override
  Stream<GetCurrentLocationStates> mapEventToState(
      GetCurrentLocationEvents event) async* {
    bool _serviceEnabled = await location.serviceEnabled();
    if (_serviceEnabled == false) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // yield Please enable location service first
        yield EnableLocationServiceStates();
      }
    }

    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        // yield Please enable location service first
        yield EnableLocationServiceStates();
      }
    }

    LocationData locationData = await location.getLocation();
    if (locationData != null) {
      Prefs.setDouble("myLat", locationData.latitude);
      Prefs.setDouble("myLong", locationData.longitude);
      yield GetCurrentLocationStatesSuccess(locationData: locationData);
    } else {
      yield GetCurrentLocationStatesFailed(
          msg:
              "Get current location failed, please try again and make sure that location service is enabled in your phone.");
    }
  }
}
