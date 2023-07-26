import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/ProductDetails/SendOffer/events.dart';
import 'package:orghub/Screens/ProductDetails/SendOffer/states.dart';

class SendOfferBloc extends Bloc<SendOfferEvents, SendOfferStates> {
  ServerGate serverGate = ServerGate();
  SendOfferBloc() : super(SendOfferStates());

  @override
  Stream<SendOfferStates> mapEventToState(SendOfferEvents event) async* {
    if (event is SendOfferEventsStart) {
      yield SendOfferStatesStart();

      CustomResponse response = await sendOffer(
        offerData: event.offerData,
      );

      if (response.success) {
        yield SendOfferStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield SendOfferStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield SendOfferStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield SendOfferStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> sendOffer({
    @required Map<String, dynamic> offerData,
  }) async {
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "client/ad_offers",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
      body: offerData,
    );

    return response;
  }
}
