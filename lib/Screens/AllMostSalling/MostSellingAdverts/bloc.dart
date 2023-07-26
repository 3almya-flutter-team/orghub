import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/AllMostSalling/MostSellingAdverts/events.dart';
import 'package:orghub/Screens/AllMostSalling/MostSellingAdverts/model.dart';
import 'package:orghub/Screens/AllMostSalling/MostSellingAdverts/states.dart';
 

class GetAllSellingAdvertsBloc
    extends Bloc<GetAllSellingAdvertsEvents, GetAllSellingAdvertsStates> {
  GetAllSellingAdvertsBloc() : super(GetAllSellingAdvertsStates());

  ServerGate serverGate = ServerGate();

  List<AdvertData> allAdverts = [];

  @override
  Stream<GetAllSellingAdvertsStates> mapEventToState(
      GetAllSellingAdvertsEvents event) async* {
    if (event is GetAllSellingAdvertsEventsStart) {
      yield GetAllSellingAdvertsStatesStart();
      CustomResponse response =
          await fetchAllSellingAdverts(pageNum: event.pageNum);
      if (response.success) {
        AdvertsModel advertsModel =
            AdvertsModel.fromJson(response.response.data);
        allAdverts = advertsModel.adverts;
         if (advertsModel.meta.total == 0) {
          yield GetAllSellingAdvertsStatesNoData();
        } else {
           yield GetAllSellingAdvertsStatesCompleted(
            empty: false,
            adverts: allAdverts,
            hasReachedPageMax: advertsModel.adverts.length <
                    advertsModel.meta.perPage
                ? true
                : false,
            hasReachedEndOfResults: false,
          );
        }
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllSellingAdvertsStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllSellingAdvertsStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetAllSellingAdvertsStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    } else if (event is GetAllNextSellingAdvertsEvents) {
      print("-=-=-[ PAGE NUMBER ]=-=-=> ${event.pageNum}");
      CustomResponse response =
          await fetchAllSellingAdverts(pageNum: event.pageNum);

      if (response.success) {
        AdvertsModel advertsModel =
            AdvertsModel.fromJson(response.response.data);

        allAdverts.addAll(advertsModel.adverts);

        if (advertsModel.meta.lastPage > 0 &&
            (advertsModel.meta.currentPage >=
                advertsModel.meta.lastPage)) {
          yield GetAllSellingAdvertsStatesCompleted(
            empty: false,
            adverts: allAdverts,
            hasReachedPageMax:
                advertsModel.adverts.length < advertsModel.meta.perPage
                    ? true
                    : false,
            hasReachedEndOfResults: true,
          );
        } else {
          yield GetAllSellingAdvertsStatesCompleted(
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
          yield GetAllSellingAdvertsStatesFailed(
            errType: response.errType,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllSellingAdvertsStatesFailed(
            errType: response.errType,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetAllSellingAdvertsStatesFailed(
            errType: response.errType,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllSellingAdverts({int pageNum}) async {
    serverGate.addInterceptors();

    String token = await Prefs.getStringF("authToken");

    CustomResponse response = await serverGate.getFromServer(
      url: "client/ads?most_type=most_sell&page=$pageNum",
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








// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:orghub/Helpers/server_gate.dart';
// import 'package:orghub/Screens/AllMostSalling/MostSellingAdverts/events.dart';
// import 'package:orghub/Screens/AllMostSalling/MostSellingAdverts/model.dart';
// import 'package:orghub/Screens/AllMostSalling/MostSellingAdverts/states.dart';


// class GetAllSellingAdvertsBloc extends Bloc<GetAllSellingAdvertsEvents, GetAllSellingAdvertsStates> {
//   GetAllSellingAdvertsBloc() : super(GetAllSellingAdvertsStates());

//   ServerGate serverGate = ServerGate();

//   @override
//   Stream<GetAllSellingAdvertsStates> mapEventToState(GetAllSellingAdvertsEvents event) async* {
//     if (event is GetAllSellingAdvertsEventsStart) {
//       yield GetAllSellingAdvertsStatesStart();
//       CustomResponse response = await fetchAllSellingAdverts();
//       if (response.success) {
//         AdvertsModel advertsModel =
//             AdvertsModel.fromJson(response.response.data);
//         yield GetAllSellingAdvertsStatesSuccess(adverts: advertsModel.adverts);
//       } else {
//         print("from map event to state show error => ");
//         print(response.error.toString());

//         if (response.errType == 0) {
//           yield GetAllSellingAdvertsStatesFailed(
//             errType: 0,
//             msg: "Network error ",
//           );
//         } else if (response.errType == 1) {
//           yield GetAllSellingAdvertsStatesFailed(
//             errType: 1,
//             msg: response.error['message'],
//           );
//         } else {
//           yield GetAllSellingAdvertsStatesFailed(
//             errType: 2,
//             msg: "Server error , please try again",
//           );
//         }
//       }
//     }
//   }

//   Future<CustomResponse> fetchAllSellingAdverts() async {
//     serverGate.addInterceptors();

//     CustomResponse response = await serverGate.getFromServer(
//       url: "client/ads?most_type=most_sell",
//       headers: {
//         "Accept": "application/json",
//         "lang": translator.currentLanguage == 'en' ? "en" : "ar",
//       },
//     );
//     return response;
//   }
// }
