import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Auth/ProviderSignUp/provider_input_model.dart';
import 'package:orghub/Screens/Profile/model.dart';
import 'package:orghub/Screens/UpdateCompanyProfile/UpdateService/events.dart';
import 'package:orghub/Screens/UpdateCompanyProfile/UpdateService/states.dart';
import 'package:path/path.dart';

class CompanyUpdateBloc extends Bloc<CompanyUpdateEvents, CompanyUpdateStates> {
  ServerGate serverGate = ServerGate();
  CompanyUpdateBloc() : super(CompanyUpdateStates());

  @override
  Stream<CompanyUpdateStates> mapEventToState(
      CompanyUpdateEvents event) async* {
    if (event is CompanyUpdateEventStart) {
      print("111111");
      // show loader ........ ?
      yield CompanyUpdateStateStart();
      print("222222");
      // Send UserData to server via Register Api
      CustomResponse response = await updateCompanyProfile(event.profileData);

      if (response.success) {
        // UserRegisterStateSuccess
        print("response => ${response.response.data.toString()}");
        // GO TO ACTIVATION PAGE ->
        yield CompanyUpdateStateSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield CompanyUpdateStateFailed(
            statusCode: response.statusCode,
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield CompanyUpdateStateFailed(
            statusCode: response.statusCode,
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield CompanyUpdateStateFailed(
            statusCode: response.statusCode,
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> updateCompanyProfile(
      Map<String, dynamic> providerInputData) async {
    print(providerInputData.toString());

    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "profile",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
      body: providerInputData,

      // {
      //   "fullname": providerInputData.fullname,
      //   "email": providerInputData.email,
      //   "password": providerInputData.password,
      //   "phone": providerInputData.phone,
      //   "whatsapp": providerInputData.whatsapp,
      //   "image": providerInputData.profileImage == null
      //       ? null
      //       : MultipartFile.fromFileSync(
      //           providerInputData.profileImage.path,
      //           filename: basename(providerInputData.profileImage.path),
      //         ),
      //   "cover": providerInputData.coverImage == null
      //       ? null
      //       : MultipartFile.fromFileSync(
      //           providerInputData.coverImage.path,
      //           filename: basename(providerInputData.coverImage.path),
      //         ),
      //   "city_id": providerInputData.cityId,
      //   "country_id": providerInputData.countryId,
      //   "gender": providerInputData.gender,
      //   "user_type": "organization",
      //   "organization_name": providerInputData.organizationName,
      //   "organization_address": providerInputData.organizationAddress,
      //   "organization_location": providerInputData.organizationLocation,
      //   "organization_lat": providerInputData.organizationLat,
      //   "organization_lng": providerInputData.organizationLng,
      //   "organization_website": providerInputData.organizationWebsite,
      //   "organization_licence_image": providerInputData
      //               .organizationlicenceimage ==
      //           null
      //       ? null
      //       : MultipartFile.fromFileSync(
      //           providerInputData.organizationlicenceimage.path,
      //           filename:
      //               basename(providerInputData.organizationlicenceimage.path),
      //         ),
      //   "organization_licence_number":
      //       providerInputData.organizationlicenceNumber,
      // },
    );

    return response;
  }
}
