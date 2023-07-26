import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Notifications/DeleteNotification/events.dart';
import 'package:orghub/Screens/Notifications/DeleteNotification/states.dart';

class NotificationsDeleteBloc extends Bloc<NotificationsDeleteEvents, NotificationsDeleteStates> {
  NotificationsDeleteBloc() : super(NotificationsDeleteStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<NotificationsDeleteStates> mapEventToState(NotificationsDeleteEvents event) async* {
    if (event is NotificationsDeleteEventsStart) {
      yield NotificationsDeleteStatesStart();
      CustomResponse response = await deleteNotification(notificationId: event.notificationId);
      if (response.success) {
        yield NotificationsDeleteStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield NotificationsDeleteStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield NotificationsDeleteStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield NotificationsDeleteStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> deleteNotification({String notificationId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.sendToServer(
      url: "notifications/$notificationId",
      body: {
        "_method":"delete",
      },
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
