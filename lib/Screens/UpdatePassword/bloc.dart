import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
// import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
// import 'dart:io' show Platform;

import 'package:orghub/Screens/UpdatePassword/events.dart';
import 'package:orghub/Screens/UpdatePassword/states.dart';

class UpdatePasswordBloc
    extends Bloc<UpdatePasswordEvents, UpdatePasswordStates> {
  UpdatePasswordBloc() : super(UpdatePasswordStates());
  ServerGate serverGate = ServerGate();

  @override
  Stream<UpdatePasswordStates> mapEventToState(
      UpdatePasswordEvents event) async* {
    if (event is UpdatePasswordEventsStart) {
      yield UpdatePasswordStatesStart();

      CustomResponse response =
          await updatePassword(newPass: event.newPass, oldPass: event.oldPass);

      if (response.success) {
        yield UpdatePasswordStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield UpdatePasswordStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield UpdatePasswordStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield UpdatePasswordStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> updatePassword(
      {String oldPass, String newPass}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.sendToServer(
      url: "edit_password",
      body: {
        "old_password": oldPass,
        "password": newPass,
      },
      headers: {
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
        "Accept": "application/json",
      },
    );

    return response;
  }
}
