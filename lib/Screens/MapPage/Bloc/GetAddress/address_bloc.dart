import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:orghub/Screens/MapPage/Bloc/GetAddress/address_events.dart';
import 'package:orghub/Screens/MapPage/Bloc/GetAddress/address_states.dart';



class GetAddressBloc extends Bloc<GetAddressEvents, GetAddressStates> {
  GetAddressBloc() : super(GetAddressStates());

  @override
  Stream<GetAddressStates> mapEventToState(GetAddressEvents event) async* {
    if (event is GetAddressEventStart) {
      yield GetAddressStateStart();

      String address = await _getCurrentAddress(
        lat: event.lat,
        long: event.long,
      );
      if (address != null) {
        yield GetAddressStateSuccess(
          address: address,
          lat: event.lat,
          long: event.long,
        );
      } else {
        yield GetAddressStateFailed();
      }
    }
  }

  // ! TO GET THE USERS LOCATION
  Future<String> _getCurrentAddress({
    @required double lat,
    @required double long,
  }) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    String address = placemarks[0].name;
    print("tefa Location : $address");

    return address;
  }
}
