import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Auth/ForgetPassword/evens.dart';
import 'package:orghub/Screens/Auth/ForgetPassword/states.dart';

class SendCodeBloc extends Bloc<SendCodeEvents, SendCodeStates> {
  SendCodeBloc() : super(SendCodeStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<SendCodeStates> mapEventToState(SendCodeEvents event) async* {
    if (event is SendCodeEventsStart) {
      yield SendCodeStatesStart();

      CustomResponse response = await sendCode(
        phone: event.phone,
      );

      if (response.success) {
        // UserRegisterStateSuccess
        print("response => ${response.response.data.toString()}");
        yield SendCodeStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield SendCodeStatesFailed(
             statusCode: response.statusCode,
            errType: 0,
            goToActivate: false,
            isActive: false,
            isBan: false,
            msg: "Network error",
          );
        } else if (response.errType == 1) {
          if (response.statusCode == 403) {
            if (response.error['is_active'] == false &&
                response.error['is_ban'] == false) {
              yield SendCodeStatesFailed(
                statusCode: response.statusCode,
                goToActivate: true,
                isActive: false,
                isBan: false,
                errType: 1,
                msg: response.error['message'],
              );
            } else if (response.error['is_ban'] == true) {
              yield SendCodeStatesFailed(
                statusCode: response.statusCode,
                goToActivate: false,
                isActive: false,
                isBan: true,
                errType: 1,
                msg: response.error['message'],
              );
            }
          } else if (response.statusCode == 401) {
            // show error message
            yield SendCodeStatesFailed(
              statusCode: response.statusCode,
              goToActivate: false,
              isActive: false,
              isBan: false,
              errType: 1,
              msg: response.error['message'],
            );
          } else {
            // show error message
            yield SendCodeStatesFailed(
              statusCode: response.statusCode,
              isActive: false,
              goToActivate: false,
              isBan: false,
              errType: 1,
              msg: response.error['message'],
            );
          }
        } else {
          yield SendCodeStatesFailed(
            statusCode: response.statusCode,
            goToActivate: false,
            errType: 2,
            isActive: false,
            isBan: false,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> sendCode({
    String phone,
  }) async {
    print("$phone ");
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "send_code",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
      },
      body: {
        "username": phone,
      },
    );

    return response;
  }
}
