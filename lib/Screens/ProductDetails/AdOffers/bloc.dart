import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/ProductDetails/AdOffers/events.dart';
import 'package:orghub/Screens/ProductDetails/AdOffers/model.dart';
import 'package:orghub/Screens/ProductDetails/AdOffers/states.dart';

class GetAddOffersBloc extends Bloc<GetAddOffersEvents, GetAddOffersStates> {
  GetAddOffersBloc() : super(GetAddOffersStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetAddOffersStates> mapEventToState(GetAddOffersEvents event) async* {
    List<OfferData> allOffers = [];
    if (event is GetAddOffersEventsSatart) {
      yield GetAddOffersStatesStart();
      CustomResponse response = await getAdOffers(advertId: event.advertId);
      if (response.success) {
        AdOffersModel offersModel =
            AdOffersModel.fromJson(response.response.data);
        allOffers.addAll(offersModel.data);
        yield GetAddOffersStatesSuccess(offers: allOffers);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());
        if (response.errType == 0) {
          yield GetAddOffersStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAddOffersStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetAddOffersStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> getAdOffers({@required int advertId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/ads/$advertId/offers?page=1",
      headers: {
        "Accept": "application/json",
        "Authorization": await Prefs.getStringF("authToken"),
      },
    );
    return response;
  }
}
