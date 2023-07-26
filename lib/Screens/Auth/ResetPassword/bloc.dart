import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Auth/ResetPassword/evens.dart';
import 'package:orghub/Screens/Auth/ResetPassword/states.dart';

class ResetPasswordeBloc
    extends Bloc<ResetPasswordeEvents, ResetPasswordeStates> {
  ResetPasswordeBloc() : super(ResetPasswordeStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<ResetPasswordeStates> mapEventToState(
      ResetPasswordeEvents event) async* {
    if (event is ResetPasswordeEventsStart) {
      yield ResetPasswordeStatesStart();

      CustomResponse response = await resetPassFunc(
        phone: event.phone,
        code: event.code,
        password: event.newPassword,
      );

      if (response.success) {
        print("response => ${response.response.data.toString()}");
        yield ResetPasswordeStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield ResetPasswordeStatesFailed(
            statusCode: response.statusCode,
            errType: 0,
            msg: "Network error",
          );
        } else if (response.errType == 1) {
          print("jkhkjhjk ${response.statusCode}");
          // if (response.statusCode == 400) {
          yield ResetPasswordeStatesFailed(
            statusCode: response.statusCode,
            errType: 1,
            msg: response.error['message'],
          );
          // } else {
          //   yield ResetPasswordeStatesFailed(
          //     statusCode: response.statusCode,
          //     errType: 2,
          //     msg: "Server error , please try again",
          //   );
          // }
        }
      }
    }
  }

  Future<CustomResponse> resetPassFunc({
    String phone,
    String code,
    String password,
  }) async {
    serverGate.addInterceptors();

    print("code =-=-=> $code");
    CustomResponse response = await serverGate.sendToServer(
      url: "reset_password",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
      },
      body: {
        "username": phone,
        "password": password,
        "code": code,
      },
    );

    return response;
  }
}
