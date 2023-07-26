import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/UpdateCompanyProfile/events.dart';
import 'package:orghub/Screens/UpdateCompanyProfile/model.dart';
import 'package:orghub/Screens/UpdateCompanyProfile/states.dart';

class GetCompanyProfileDataBloc
    extends Bloc<GetCompanyProfileEvent, GetCompanyProfileState> {
  GetCompanyProfileDataBloc() : super(GetCompanyProfileState());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetCompanyProfileState> mapEventToState(
      GetCompanyProfileEvent event) async* {
    if (event is GetCompanyProfileEventStart) {
      yield GetCompanyProfileStateStart();
      CustomResponse response =
          await getCompanyProfileData();
      if (response.success) {
        CompanyProfileModel profileModel =
            CompanyProfileModel.fromJson(response.response.data);
        yield GetCompanyProfileStateSuccess(companyProfileModel: profileModel);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetCompanyProfileStateFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetCompanyProfileStateFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetCompanyProfileStateFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> getCompanyProfileData() async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "profile",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}