import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Notifications/events.dart';
import 'package:orghub/Screens/Notifications/model.dart';
import 'package:orghub/Screens/Notifications/states.dart';

class GetNotificationsBloc
    extends Bloc<GetNotificationsEvents, GetNotificationsStates> {
  GetNotificationsBloc() : super(GetNotificationsStates());

  ServerGate serverGate = ServerGate();

  List<NotificationData> _notifications = [];

  @override
  Stream<GetNotificationsStates> mapEventToState(
      GetNotificationsEvents event) async* {
    if (event is GetNotificationsEventsStart) {
      yield GetNotificationsStatesStart();
      CustomResponse response = await fetchAllNotifications(pageNum: 1);
      if (response.success) {
        NotificationsModel notificationsModel =
            NotificationsModel.fromJson(response.response.data);
        _notifications.addAll(notificationsModel.data);

        if (notificationsModel.meta.total == 0) {
          yield GetNotificationsStatesNoData();
        } else {
           yield GetNotificationsStatesCompleted(
            empty: false,
            notifications: _notifications,
            hasReachedPageMax: notificationsModel.data.length <
                    notificationsModel.meta.perPage
                ? true
                : false,
            hasReachedEndOfResults: false,
          );
        }
        // yield GetNotificationsStatesSuccess(notifications: _notifications);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetNotificationsStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetNotificationsStatesFailed(
            errType: 1,
             statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetNotificationsStatesFailed(
            errType: 2,
             statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }else if(event is GetNextNotificationsEvent){
          print("-=-=-[ PAGE NUMBER ]=-=-=> ${event.pageNum}");
       CustomResponse response = await fetchAllNotifications(pageNum: event.pageNum);

      if (response.success) {

        NotificationsModel notificationsModel =
            NotificationsModel.fromJson(response.response.data);
        _notifications.addAll(notificationsModel.data);
        


        if (notificationsModel.meta.lastPage > 0 &&
            (notificationsModel.meta.currentPage >=
                notificationsModel.meta.lastPage)) {
          yield GetNotificationsStatesCompleted(
            empty: false,
            notifications: _notifications,
            hasReachedPageMax: notificationsModel.data.length <
                    notificationsModel.meta.perPage
                ? true
                : false,
            hasReachedEndOfResults: true,
          );
        } else {
          yield GetNotificationsStatesCompleted(
            empty: false,
            notifications: _notifications,
            hasReachedPageMax: notificationsModel.data.length <
                    notificationsModel.meta.perPage
                ? true
                : false,
            hasReachedEndOfResults: false,
          );
        }
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetNotificationsStatesFailed(
            errType: response.errType,
             statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetNotificationsStatesFailed(
            errType: response.errType,
             statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetNotificationsStatesFailed(
            errType: response.errType,
             statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllNotifications({int pageNum}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "notifications?page=$pageNum",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
