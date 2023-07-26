import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Auth/ProviderSignUp/events.dart';
import 'package:orghub/Screens/Auth/ProviderSignUp/provider_input_model.dart';
import 'package:orghub/Screens/Auth/ProviderSignUp/states.dart';
import 'package:path/path.dart';
import 'dart:io' show Platform;

class ProviderSignUpBloc
    extends Bloc<ProviderRegisterEvents, ProviderRegisterStates> {
  ServerGate serverGate = ServerGate();
  ProviderSignUpBloc() : super(ProviderRegisterStates());

  @override
  Stream<ProviderRegisterStates> mapEventToState(
      ProviderRegisterEvents event) async* {
    if (event is ProviderRegisterEventStart) {
      print("111111");
      // show loader ........ ?
      yield ProviderRegisterStateStart();
      print("222222");
      // Send UserData to server via Register Api
      CustomResponse response = await registerService(event.providerInputData);

      if (response.success) {
        // UserRegisterStateSuccess
        print("response => ${response.response.data.toString()}");
        // GO TO ACTIVATION PAGE ->
        yield ProviderRegisterStateSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield ProviderRegisterStateFailed(
            statusCode: response.statusCode,
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield ProviderRegisterStateFailed(
            statusCode: response.statusCode,
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield ProviderRegisterStateFailed(
            statusCode: response.statusCode,
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> registerService(
      ProviderInputData providerInputData) async {
    print(providerInputData.toJson().toString());
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "register",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
      },
      body: {
        "fullname": providerInputData.fullname,
        "email": providerInputData.email,
        "password": providerInputData.password,
        "phone": providerInputData.phone,
        "whatsapp": providerInputData.whatsapp,
        "image": providerInputData.profileImage == null
            ? null
            : MultipartFile.fromFileSync(
                providerInputData.profileImage.path,
                filename: basename(providerInputData.profileImage.path),
              ),
        //  "device_token": await Prefs.getStringF("msgToken"),
        //   "type": Platform.isAndroid ? "android" : "ios",
        "city_id": providerInputData.cityId,
        "country_id": providerInputData.countryId,
        "gender": providerInputData.gender,
        "user_type": "organization",
        "organization_name": providerInputData.organizationName,
        "organization_address": providerInputData.organizationAddress,
        "organization_location": providerInputData.organizationLocation,
        "organization_lat": providerInputData.organizationLat,
        "organization_lng": providerInputData.organizationLng,
        "organization_website": providerInputData.organizationWebsite,
        "organization_licence_image": providerInputData
                    .organizationlicenceimage ==
                null
            ? null
            : MultipartFile.fromFileSync(
                providerInputData.organizationlicenceimage.path,
                filename:
                    basename(providerInputData.organizationlicenceimage.path),
              ),
        "organization_licence_number":
            providerInputData.organizationlicenceNumber,
      },
    );

    return response;
  }
}
