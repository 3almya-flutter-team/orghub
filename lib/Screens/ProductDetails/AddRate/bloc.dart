import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/ProductDetails/AddRate/events.dart';
import 'package:orghub/Screens/ProductDetails/AddRate/states.dart';

class RateAdvertBloc extends Bloc<RateAdvertEvents, RateAdvertStates> {
  ServerGate serverGate = ServerGate();
  RateAdvertBloc() : super(RateAdvertStates());

  @override
  Stream<RateAdvertStates> mapEventToState(RateAdvertEvents event) async* {
    if (event is RateAdvertEvevntsStart) {
      yield RateAdvertStatesStart();

      CustomResponse response = await rateAdvert(
        advertId: event.advertId,
        rate: event.rate,
        review: event.review,
      );

      if (response.success) {
        print("response => ${response.response.data.toString()}");

        yield RateAdvertStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield RateAdvertStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield RateAdvertStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield RateAdvertStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> rateAdvert({
    @required int advertId,
    @required double rate,
    String review,
  }) async {
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "rates",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
      body: {
        "ad_id": advertId,
        "rate": rate,
        "review": review,
      },
    );

    return response;
  }
}
