import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Favourite/events.dart';
import 'package:orghub/Screens/Favourite/model.dart';
import 'package:orghub/Screens/Favourite/states.dart';

class GetAllFavAdsBloc extends Bloc<GetAllFavAdsEvents, GetAllFavAdsStates> {
  GetAllFavAdsBloc() : super(GetAllFavAdsStates());

  ServerGate serverGate = ServerGate();
  List<FavAdData> allFavs = [];
  @override
  Stream<GetAllFavAdsStates> mapEventToState(GetAllFavAdsEvents event) async* {
    if (event is GetAllFavAdsEventsStart) {
      yield GetAllFavAdsStatesStart();

      CustomResponse response = await fetchAllFavAds(pageNum: 1);
      if (response.success) {
        AllFavAdsModel adsModel =
            AllFavAdsModel.fromJson(response.response.data);
        allFavs.addAll(adsModel.data);
        yield GetAllFavAdsStatesSuccess(allFavAdverts: allFavs);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllFavAdsStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllFavAdsStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetAllFavAdsStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllFavAds({int pageNum}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "favourites?page=$pageNum",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
