import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Auth/SignIn/events.dart';
import 'package:orghub/Screens/Auth/SignIn/model.dart';
import 'package:orghub/Screens/Auth/SignIn/states.dart';
import 'package:orghub/Screens/Auth/SignIn/view.dart';
import 'dart:io' show Platform;

class UserLoginBloc extends Bloc<UserLoginEvents, UserLoginStates> {
  UserLoginBloc() : super(UserLoginStates());
  ServerGate serverGate = ServerGate();

  @override
  Stream<UserLoginStates> mapEventToState(UserLoginEvents event) async* {
    if (event is UserLoginEventsStart) {
      yield UserLoginStatesStart();

      CustomResponse response =
          await userLogin(userLoginData: event.userLoginData);

      if (response.success) {
        UserLoginModel userLoginModel =
            UserLoginModel.fromJson(response.response.data);
        Prefs.setString("authToken", userLoginModel.data.token);
        Prefs.setInt("userId", userLoginModel.data.id);
        Prefs.setString("userType", userLoginModel.data.userType);

        yield UserLoginStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield UserLoginStatesFailed(
            statusCode: response.statusCode,
            errType: 0,
            goToActivate: false,
            isActive: false,
            isBan: false,
            msg: "Network error",
            userName: null,
          );
        } else if (response.errType == 1) {
          // print("from xxxxx => ${response.error['message']}");
          if (response.statusCode == 403) {
            if (response.error['is_active'] == false &&
                response.error['is_ban'] == false) {
              print("=-=-=> ${response.error.toString()}");
              yield UserLoginStatesFailed(
                statusCode: response.statusCode,
                goToActivate: true,
                isActive: false,
                isBan: false,
                errType: 1,
                msg: response.error['message'],
                userName: response.error['username'],
              );
            } else if (response.error['is_ban'] == true) {
              yield UserLoginStatesFailed(
                statusCode: response.statusCode,
                goToActivate: false,
                isActive: false,
                isBan: true,
                errType: 1,
                msg: response.error['message'],
                userName: null,
              );
            }
          } else if (response.statusCode == 401) {
            // show error message
            yield UserLoginStatesFailed(
              statusCode: response.statusCode,
              goToActivate: false,
              isActive: false,
              isBan: false,
              errType: 1,
              msg: response.error['message'],
              userName: null,
            );
          } else {
            // show error message
            yield UserLoginStatesFailed(
              statusCode: response.statusCode,
              isActive: false,
              goToActivate: false,
              isBan: false,
              errType: 1,
              msg: response.error['message'],
              userName: null,
            );
          }
        } else {
          // show error message
          yield UserLoginStatesFailed(
            statusCode: response.statusCode,
            goToActivate: false,
            errType: 2,
            isActive: false,
            isBan: false,
            msg: "Server error , please try again",
            userName: null,
          );
        }
      }
    }
  }

  Future<CustomResponse> userLogin({UserLoginData userLoginData}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.sendToServer(
      url: "login",
      body: {
        "username": userLoginData.phone,
        "password": userLoginData.password,
        "device_token": await Prefs.getStringF("msgToken"),
        "type": Platform.isAndroid ? "android" : "ios",
      },
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
      },
    );

    return response;
  }
}
