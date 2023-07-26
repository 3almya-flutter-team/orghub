import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Auth/LogoutService/events.dart';
import 'package:orghub/Screens/Auth/LogoutService/states.dart';
import 'dart:io' show Platform;

class LogoutBloc extends Bloc<LogoutEvents, LogoutStates> {
  LogoutBloc() : super(LogoutStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<LogoutStates> mapEventToState(LogoutEvents event) async* {
    if (event is LogoutEventStart) {
      yield LogoutStateStart();
      CustomResponse response = await logoutService();
      if (response.success) {
        Prefs.clear();
        yield LogoutStateSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield LogoutStateFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield LogoutStateFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield LogoutStateFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> logoutService() async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.sendToServer(
      url: "logout",
      body: {
        "device_token": await Prefs.getStringF("msgToken"),
        "type": Platform.isAndroid ? "android" : "ios",
      },
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
