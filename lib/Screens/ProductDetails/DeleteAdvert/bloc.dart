import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/ProductDetails/DeleteAdvert/events.dart';
import 'package:orghub/Screens/ProductDetails/DeleteAdvert/states.dart';

class DeleteAdvertBloc
    extends Bloc<DeleteAdvertEvents, DeleteAdvertStates> {
  ServerGate serverGate = ServerGate();
  DeleteAdvertBloc() : super(DeleteAdvertStates());

  @override
  Stream<DeleteAdvertStates> mapEventToState(
      DeleteAdvertEvents event) async* {
    if (event is DeleteAdvertEvevntsStart) {
      yield DeleteAdvertStatesStart();

      CustomResponse response = await deleteAdvert(
        advertId: event.advertId,
      );

      if (response.success) {
        print("response => ${response.response.data.toString()}");
        
        yield DeleteAdvertStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield DeleteAdvertStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield DeleteAdvertStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield DeleteAdvertStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> deleteAdvert({
    @required int advertId,
  }) async {
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "client/ads/$advertId",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
      body: {
        "_method": "delete",
      },
    );

    return response;
  }
}
