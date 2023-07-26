import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Categories/GetAdsInCategory/events.dart';
import 'package:orghub/Screens/Categories/GetAdsInCategory/states.dart';
import 'package:orghub/Screens/Home/MostSellingAdverts/model.dart';

class GetCategoryAdsBloc
    extends Bloc<GetCategoryAdsEvents, GetCategoryAdsStates> {
  GetCategoryAdsBloc() : super(GetCategoryAdsStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetCategoryAdsStates> mapEventToState(
      GetCategoryAdsEvents event) async* {
    if (event is GetCategoryAdsEventsStart) {
      yield GetCategoryAdsStatesStart();
      CustomResponse response =
          await getCategoryAds(catId: event.catId, adType: event.adType);
      if (response.success) {
        AdvertsModel advertsModel =
            AdvertsModel.fromJson(response.response.data);
        yield GetCategoryAdsStatesSuccess(adverts: advertsModel.adverts);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetCategoryAdsStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetCategoryAdsStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetCategoryAdsStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> getCategoryAds({int catId, String adType}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "categories/$catId?ad_type=$adType",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
