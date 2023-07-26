import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/ProductDetails/RelatedAds/events.dart';
import 'package:orghub/Screens/ProductDetails/RelatedAds/model.dart';
import 'package:orghub/Screens/ProductDetails/RelatedAds/states.dart';

class GetRelatedAdvertsBloc
    extends Bloc<GetRelatedAdvertsEvents, GetRelatedAdvertsStates> {
  GetRelatedAdvertsBloc() : super(GetRelatedAdvertsStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetRelatedAdvertsStates> mapEventToState(
      GetRelatedAdvertsEvents event) async* {
    if (event is GetRelatedAdvertsEventsStart) {
      yield GetRelatedAdvertsStatesStart();
      CustomResponse response =
          await fetchRelatedAdverts(advertId: event.advertId);
      if (response.success) {
        AdvertsModel advertsModel =
            AdvertsModel.fromJson(response.response.data);
        yield GetRelatedAdvertsStatesSuccess(adverts: advertsModel.adverts);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetRelatedAdvertsStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetRelatedAdvertsStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield GetRelatedAdvertsStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchRelatedAdverts({@required int advertId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/related_ads/$advertId?page=1",
      headers: {
        "Accept": "application/json",
        "Authorization": await Prefs.getStringF("authToken"),
      },
    );
    return response;
  }
}
