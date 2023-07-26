import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Home/MostSellingAdverts/events.dart';
import 'package:orghub/Screens/Home/MostSellingAdverts/model.dart';
import 'package:orghub/Screens/Home/MostSellingAdverts/states.dart';

class GetMostSellingAdvertsBloc extends Bloc<GetMostSellingAdvertsEvents, GetMostSellingAdvertsStates> {
  GetMostSellingAdvertsBloc() : super(GetMostSellingAdvertsStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetMostSellingAdvertsStates> mapEventToState(GetMostSellingAdvertsEvents event) async* {
    if (event is GetMostSellingAdvertsEventsStart) {
      yield GetMostSellingAdvertsStatesStart();
      CustomResponse response = await fetchMostSellingAdverts();
      if (response.success) {
        AdvertsModel advertsModel =
            AdvertsModel.fromJson(response.response.data);
        yield GetMostSellingAdvertsStatesSuccess(adverts: advertsModel.adverts);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetMostSellingAdvertsStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetMostSellingAdvertsStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetMostSellingAdvertsStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchMostSellingAdverts() async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/ads?most_type=most_sell",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
