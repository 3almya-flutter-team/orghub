import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/ProductDetails/events.dart';
import 'package:orghub/Screens/ProductDetails/model.dart';
import 'package:orghub/Screens/ProductDetails/states.dart';

class GetSingleAdvertDataBloc
    extends Bloc<GetSingleAdvertEvents, GetSingleAdvertStates> {
  GetSingleAdvertDataBloc() : super(GetSingleAdvertStates());

  ServerGate serverGate = ServerGate();
  // List<Tag> adTags = [];

  @override
  Stream<GetSingleAdvertStates> mapEventToState(
      GetSingleAdvertEvents event) async* {
    if (event is GetSingleAdvertEventsStart) {
      yield GetSingleAdvertStatesStart();
      CustomResponse response =
          await getSingleAdvertData(advertId: event.advertId);
      if (response.success) {
        SingleAdvertModel singleAdvertModel =
            SingleAdvertModel.fromJson(response.response.data);
        // adTags.addAll(singleAdvertModel.data.tags);
        yield GetSingleAdvertStatesSuccess(advertData: singleAdvertModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetSingleAdvertStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetSingleAdvertStatesFailed(
            errType: 1,
              statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetSingleAdvertStatesFailed(
            errType: 2,
              statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> getSingleAdvertData({@required int advertId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/ads/$advertId",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
