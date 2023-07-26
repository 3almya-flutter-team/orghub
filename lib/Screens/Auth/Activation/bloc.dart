import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'dart:io' show Platform;
import 'package:orghub/Screens/Auth/Activation/events.dart';
import 'package:orghub/Screens/Auth/Activation/model.dart';
import 'package:orghub/Screens/Auth/Activation/states.dart';

class ActivateAccountBloc
    extends Bloc<ActivateAccountEvents, ActivateAccountStates> {
  ActivateAccountBloc() : super(ActivateAccountStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<ActivateAccountStates> mapEventToState(
      ActivateAccountEvents event) async* {
    if (event is ActivateAccountEventsStart) {
      yield ActivateAccountStatesStart();

      CustomResponse response = await activateAccount(
        code: event.code,
        phone: event.phone,
      );

      if (response.success) {
        // UserRegisterStateSuccess
        print("response => ${response.response.data.toString()}");
        CompanyActivationModel companyActivationModel =
            CompanyActivationModel.fromJson(response.response.data);
        Prefs.setString("authToken", companyActivationModel.data.token);
        Prefs.setInt("userId", companyActivationModel.data.id);
        Prefs.setString("userType", companyActivationModel.data.userType);
        // GO TO Home PAGE ->
        yield ActivateAccountStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield ActivateAccountStatesFailed(
            statusCode: response.statusCode,
            errType: 0,
            msg: "Network error",
          );
        } else if (response.errType == 1) {
          // print("from xxxxx => ${response.error['message']}");
          yield ActivateAccountStatesFailed(
            statusCode: response.statusCode,
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield ActivateAccountStatesFailed(
            statusCode: response.statusCode,
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> activateAccount({
    String phone,
    String code,
  }) async {
    print("$phone $code");
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "verify",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
      },
      body: {
        "code": code,
        "username": phone,
        "device_token": await Prefs.getStringF("msgToken"),
        "type": Platform.isAndroid ? "android" : "ios",
        
      },
    );

    return response;
  }
}
