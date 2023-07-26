import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/AllComments/events.dart';
import 'package:orghub/Screens/AllComments/states.dart';
import 'package:orghub/Screens/MyComments/model.dart';

class GetAllAdsCommentsBloc
    extends Bloc<GetAllAdsCommentsEvents, GetAllAdsCommentsStates> {
  GetAllAdsCommentsBloc() : super(GetAllAdsCommentsStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetAllAdsCommentsStates> mapEventToState(
      GetAllAdsCommentsEvents event) async* {
    if (event is GetAllAdsCommentsEventsStart) {
      yield GetAllAdsCommentsStatesStart();
      var fetchAllAdsComments2 = fetchAllAdsComments(advertId: event.advertId);
      CustomResponse response = await fetchAllAdsComments2;
      if (response.success) {
        MyCommentsModel myCommentsModel =
            MyCommentsModel.fromJson(response.response.data);
        yield GetAllAdsCommentsStatesSuccess(myComments: myCommentsModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllAdsCommentsStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllAdsCommentsStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetAllAdsCommentsStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllAdsComments({@required int advertId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/ads/$advertId/reviews",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
