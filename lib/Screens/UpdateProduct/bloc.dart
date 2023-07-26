import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/UpdateProduct/events.dart';
import 'package:orghub/Screens/UpdateProduct/states.dart';

class UpdateAdvertBloc extends Bloc<UpdateAdvertEvent, UpdateAdvertStates> {
  ServerGate serverGate = ServerGate();
  UpdateAdvertBloc() : super(UpdateAdvertStates());

  @override
  Stream<UpdateAdvertStates> mapEventToState(UpdateAdvertEvent event) async* {
    if (event is UpdateAdvertEventStart) {
      // show loader ........ ?
      yield UpdateAdvertStatesStart();

      CustomResponse response = await updateAdvert(
          advertId: event.advertId, advertData: event.advertData);

      if (response.success) {
        print("response => ${response.response.data.toString()}");

        yield UpdateAdvertStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield UpdateAdvertStatesFailed(
            statusCode: response.statusCode,
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield UpdateAdvertStatesFailed(
            statusCode: response.statusCode,
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield UpdateAdvertStatesFailed(
            statusCode: response.statusCode,
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> updateAdvert({
    @required int advertId,
    @required Map<String, dynamic> advertData,
  }) async {
    print("=-=-=-=-=-> $advertData");
    print("=-=-=-=-=-> $advertId");
    print("Bearer ${await Prefs.getStringF("authToken")}");
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "client/ads/$advertId",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
      body: advertData,
    );

    return response;
  }
}
