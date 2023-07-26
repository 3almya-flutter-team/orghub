import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/OffersHistory/events.dart';
import 'package:orghub/Screens/OffersHistory/states.dart';
import 'package:orghub/Screens/ProductDetails/AdOffers/model.dart';

class GetMyOffersBloc extends Bloc<GetMyOffersEvents, GetMyOffersStates> {
  GetMyOffersBloc() : super(GetMyOffersStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetMyOffersStates> mapEventToState(GetMyOffersEvents event) async* {
    if (event is GetMyOffersEventsSatart) {
      yield GetMyOffersStatesStart();
      CustomResponse response = await getMyOffers();
      if (response.success) {
        AdOffersModel offersModel =
            AdOffersModel.fromJson(response.response.data);
        yield GetMyOffersStatesSuccess(offers: offersModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetMyOffersStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetMyOffersStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetMyOffersStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> getMyOffers() async {
    serverGate.addInterceptors();
    print("from my offers =-==-> ${await Prefs.getStringF("authToken")}");
    CustomResponse response = await serverGate.getFromServer(
      url: "client/ad_offers",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
