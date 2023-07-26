import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Profile/OtherComments/events.dart';
import 'package:orghub/Screens/Profile/OtherComments/model.dart';
import 'package:orghub/Screens/Profile/OtherComments/states.dart';

class GetUserCommentsBloc
    extends Bloc<GetUserCommentsEvents, GetUserCommentsStates> {
  GetUserCommentsBloc() : super(GetUserCommentsStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetUserCommentsStates> mapEventToState(
      GetUserCommentsEvents event) async* {
    if (event is GetUserCommentsEventsStart) {
      yield GetUserCommentsStatesStart();
      CustomResponse response = await fetchUserComments(userId: event.userId);
      if (response.success) {
        UserCommentsModel userCommentsModel =
            UserCommentsModel.fromJson(response.response.data);
        yield GetUserCommentsStatesSuccess(
            userComments: userCommentsModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetUserCommentsStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetUserCommentsStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetUserCommentsStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchUserComments({@required int userId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/$userId/comments",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
