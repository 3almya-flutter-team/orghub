import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/OfferDetail/events.dart';
import 'package:orghub/Screens/OfferDetail/states.dart';

import 'model.dart';

class GetSingleOfferBloc
    extends Bloc<GetSingleOfferEvents, GetSingleOfferStates> {
  ServerGate serverGate = ServerGate();
  GetSingleOfferBloc() : super(GetSingleOfferStates());

  @override
  Stream<GetSingleOfferStates> mapEventToState(
      GetSingleOfferEvents event) async* {
    if (event is GetSingleOfferEventsStart) {
      // show loader ........ ?
      yield GetSingleOfferStatesStart();

      CustomResponse response = await getSingleOffer(event.offerId);

      if (response.success) {
        print("response => ${response.response.data.toString()}");
        OfferDetailModel offerDetailModel =
            OfferDetailModel.fromJson(response.response.data);

        yield GetSingleOfferStatesSuccess(
            offerData: offerDetailModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetSingleOfferStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield GetSingleOfferStatesFailed(
            errType: 1,
             statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetSingleOfferStatesFailed(
            errType: 2,
             statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> getSingleOffer(int offerId) async {
    print(offerId.toString());
    print("Bearer ${await Prefs.getStringF("authToken")}");
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.getFromServer(
      url: "client/ad_offers/$offerId",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );

    return response;
  }
}
