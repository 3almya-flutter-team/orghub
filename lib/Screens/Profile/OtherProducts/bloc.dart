import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Profile/OtherProducts/events.dart';
import 'package:orghub/Screens/Profile/OtherProducts/model.dart';
import 'package:orghub/Screens/Profile/OtherProducts/states.dart';

class GetUserProductsBloc extends Bloc<GetUserProductsEvents, GetUserProductsStates> {
  GetUserProductsBloc() : super(GetUserProductsStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetUserProductsStates> mapEventToState(GetUserProductsEvents event) async* {
    if (event is GetUserProductsEventsStart) {
      yield GetUserProductsStatesStart();
      CustomResponse response = await fetchAllUserAds(userId: event.userId);
      if (response.success) {
        UserAdsModel userAdsModel =
            UserAdsModel.fromJson(response.response.data);
        yield GetUserProductsStatesSuccess(userAdsModel: userAdsModel);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetUserProductsStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetUserProductsStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetUserProductsStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllUserAds({@required int userId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/$userId/ads",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
