import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Auth/CheckCode/events.dart';
import 'package:orghub/Screens/Auth/CheckCode/states.dart';

class CheckCodeBloc extends Bloc<CheckCodeEvents, CheckCodeStates> {
  CheckCodeBloc() : super(CheckCodeStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<CheckCodeStates> mapEventToState(CheckCodeEvents event) async* {
    if (event is CheckCodeEventsStart) {
      yield CheckCodeStatesStart();

      CustomResponse response = await checkCode(
        code: event.code,
        phone: event.phone,
      );

      if (response.success) {
        print("response => ${response.response.data.toString()}");
       
        // GO TO Home PAGE ->
        yield CheckCodeStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield CheckCodeStatesFailed(
            statusCode: response.statusCode,
            errType: 0,
            msg: "Network error",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield CheckCodeStatesFailed(
            statusCode: response.statusCode,
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield CheckCodeStatesFailed(
            statusCode: response.statusCode,
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> checkCode({
    String phone,
    String code,
  }) async {
    print("$phone $code");
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "check_code",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
      },
      body: {
        "code": code,
        "username": phone,
      },
    );

    return response;
  }
}
