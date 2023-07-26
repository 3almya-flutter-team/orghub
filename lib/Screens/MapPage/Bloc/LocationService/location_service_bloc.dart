import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Screens/MapPage/Bloc/LocationService/location_events.dart';
import 'package:orghub/Screens/MapPage/Bloc/LocationService/location_states.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationServiceBloc
    extends Bloc<LocationServiceEvents, LocationServiceStates> {
  LocationServiceBloc() : super(LocationServiceStates());

  @override
  Stream<LocationServiceStates> mapEventToState(
      LocationServiceEvents event) async* {
    if (event is LocationServiceEventsStart) {
      yield LocationServiceStatesStart();

      bool locationServiceEnabled = await isLocationServiceEnabled();

      if (locationServiceEnabled) {
        yield LocationServiceStatesEnabled();
      } else {
        yield LocationServiceStatesDisabled();
      }
    }
  }

  Future<bool> isLocationServiceEnabled() async {
    bool enabled = await Permission.locationWhenInUse.serviceStatus.isEnabled;
    bool locationServiceIsPermanentlyDenied =
        await Permission.location.isPermanentlyDenied;

    print("enabled =-=> $enabled");
    print("locationServiceIsPermanentlyDenied =-=> $locationServiceIsPermanentlyDenied");

    if (!locationServiceIsPermanentlyDenied && enabled) {
      return true;
    } else {
      // Here we must open app settings to let him enable location service
      return false;
    }
  }
}
