import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Profile/AddRate/events.dart';
import 'package:orghub/Screens/Profile/AddRate/states.dart';

class RateUserBloc extends Bloc<RateUserEvents, RateUserStates> {
  ServerGate serverGate = ServerGate();
  RateUserBloc() : super(RateUserStates());

  @override
  Stream<RateUserStates> mapEventToState(RateUserEvents event) async* {
    if (event is RateUserEvevntsStart) {
      yield RateUserStatesStart();

      CustomResponse response = await rateUser(
        userId: event.userId,
        rate: event.rate,
        review: event.review,
      );

      if (response.success) {
        print("response => ${response.response.data.toString()}");

        yield RateUserStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield RateUserStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield RateUserStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield RateUserStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> rateUser({
    @required int userId,
    @required double rate,
    String review,
  }) async {
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "client/$userId/set_rate",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
      body: {
        "rate": rate,
        "review": review,
      },
    );

    return response;
  }
}
