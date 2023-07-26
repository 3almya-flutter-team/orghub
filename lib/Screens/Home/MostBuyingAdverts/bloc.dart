import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Home/MostBuyingAdverts/events.dart';
import 'package:orghub/Screens/Home/MostBuyingAdverts/model.dart';
import 'package:orghub/Screens/Home/MostBuyingAdverts/states.dart';

class GetMostBuyingAdvertsBloc extends Bloc<GetMostBuyingAdvertsEvents, GetMostBuyingAdvertsStates> {
  GetMostBuyingAdvertsBloc() : super(GetMostBuyingAdvertsStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetMostBuyingAdvertsStates> mapEventToState(GetMostBuyingAdvertsEvents event) async* {
    if (event is GetMostBuyingAdvertsEventsStart) {
      yield GetMostBuyingAdvertsStatesStart();
      CustomResponse response = await fetchMostBuyingAdverts();
      if (response.success) {
        AdvertsModel advertsModel =
            AdvertsModel.fromJson(response.response.data);
        yield GetMostBuyingAdvertsStatesSuccess(adverts: advertsModel.adverts);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetMostBuyingAdvertsStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetMostBuyingAdvertsStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetMostBuyingAdvertsStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchMostBuyingAdverts() async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/ads?most_type=most_buy",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
