import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Auth/ClientSignUp/client_input_model.dart';
import 'package:orghub/Screens/Auth/ClientSignUp/events.dart';

import 'package:orghub/Screens/Auth/ClientSignUp/states.dart';
import 'package:path/path.dart';
import 'dart:io' show Platform;

class ClientSignUpBloc
    extends Bloc<ClientRegisterEvents, ClientRegisterStates> {
  ServerGate serverGate = ServerGate();
  ClientSignUpBloc() : super(ClientRegisterStates());

  @override
  Stream<ClientRegisterStates> mapEventToState(
      ClientRegisterEvents event) async* {
    if (event is ClientRegisterEventStart) {
      print("111111");
      // show loader ........ ?
      yield ClientRegisterStateStart();
      print("222222");
      // Send UserData to server via Register Api
      CustomResponse response = await registerService(event.clientInputData);

      if (response.success) {
        // UserRegisterStateSuccess
        print("response => ${response.response.data.toString()}");
        // GO TO ACTIVATION PAGE ->
        yield ClientRegisterStateSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield ClientRegisterStateFailed(
            statusCode: response.statusCode,
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield ClientRegisterStateFailed(
            statusCode: response.statusCode,
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield ClientRegisterStateFailed(
            statusCode: response.statusCode,
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> registerService(
      ClientInputData clientInputData) async {
    print(clientInputData.toJson().toString());
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "register",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
      },
      body: {
        // "device_token": await Prefs.getStringF("msgToken"),
        // "type": Platform.isAndroid ? "android" : "ios",
        "fullname": clientInputData.fullname,
        "email": clientInputData.email,
        "password": clientInputData.password,
        "phone": clientInputData.phone,
        "whatsapp": clientInputData.whatsapp,
        "image": clientInputData.profileImage == null ? null: MultipartFile.fromFileSync(
          clientInputData.profileImage.path,
          filename: basename(clientInputData.profileImage.path),
        ),
        "city_id": clientInputData.cityId,
        "country_id": clientInputData.countryId,
        "gender": clientInputData.gender,
        "user_type": "client",
      },
    );

    return response;
  }
}
