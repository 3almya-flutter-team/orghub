import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/AllMostRequired/AllBuyingAdverts/events.dart';
import 'package:orghub/Screens/AllMostRequired/AllBuyingAdverts/model.dart';
import 'package:orghub/Screens/AllMostRequired/AllBuyingAdverts/states.dart';

class GetAllBuyingAdvertsBloc
    extends Bloc<GetAllBuyingAdvertsEvents, GetAllBuyingAdvertsStates> {
  GetAllBuyingAdvertsBloc() : super(GetAllBuyingAdvertsStates());

  ServerGate serverGate = ServerGate();

  List<AdvertData> allAdverts = [];

  @override
  Stream<GetAllBuyingAdvertsStates> mapEventToState(
      GetAllBuyingAdvertsEvents event) async* {
    if (event is GetAllBuyingAdvertsEventsStart) {
      yield GetAllBuyingAdvertsStatesStart();
      CustomResponse response =
          await fetchAllBuyingAdverts(pageNum: event.pageNum);
      if (response.success) {
        AdvertsModel advertsModel =
            AdvertsModel.fromJson(response.response.data);
        allAdverts = advertsModel.adverts;
        if (advertsModel.meta.total == 0) {
          yield GetAllBuyingAdvertsStatesNoData();
        } else {
          yield GetAllBuyingAdvertsStatesCompleted(
            empty: false,
            adverts: allAdverts,
            hasReachedPageMax:
                advertsModel.adverts.length < advertsModel.meta.perPage
                    ? true
                    : false,
            hasReachedEndOfResults: false,
          );
        }
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllBuyingAdvertsStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllBuyingAdvertsStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield GetAllBuyingAdvertsStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    } else if (event is GetAllNextBuyingAdvertsEvents) {
      print("-=-=-[ PAGE NUMBER ]=-=-=> ${event.pageNum}");
      CustomResponse response =
          await fetchAllBuyingAdverts(pageNum: event.pageNum);

      if (response.success) {
        AdvertsModel advertsModel =
            AdvertsModel.fromJson(response.response.data);

        allAdverts.addAll(advertsModel.adverts);

        if (advertsModel.meta.lastPage > 0 &&
            (advertsModel.meta.currentPage >= advertsModel.meta.lastPage)) {
          yield GetAllBuyingAdvertsStatesCompleted(
            empty: false,
            adverts: allAdverts,
            hasReachedPageMax:
                advertsModel.adverts.length < advertsModel.meta.perPage
                    ? true
                    : false,
            hasReachedEndOfResults: true,
          );
        } else {
          yield GetAllBuyingAdvertsStatesCompleted(
            empty: false,
            adverts: allAdverts,
            hasReachedPageMax:
                advertsModel.adverts.length < advertsModel.meta.perPage
                    ? true
                    : false,
            hasReachedEndOfResults: false,
          );
        }
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllBuyingAdvertsStatesFailed(
            errType: response.errType,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllBuyingAdvertsStatesFailed(
            errType: response.errType,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetAllBuyingAdvertsStatesFailed(
            errType: response.errType,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllBuyingAdverts({int pageNum}) async {
    serverGate.addInterceptors();

    String token = await Prefs.getStringF("authToken");

    CustomResponse response = await serverGate.getFromServer(
      url: "client/ads?most_type=most_buy&page=$pageNum",
      headers: token == null || token == ''
          ? {
              "Accept": "application/json",
              "lang": translator.currentLanguage == 'en' ? "en" : "ar",
            }
          : {
              "Accept": "application/json",
              "lang": translator.currentLanguage == 'en' ? "en" : "ar",
              "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
            },
    );
    return response;
  }
}
