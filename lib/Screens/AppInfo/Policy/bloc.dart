import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/AppInfo/Policy/events.dart';
import 'package:orghub/Screens/AppInfo/Policy/model.dart';
import 'package:orghub/Screens/AppInfo/Policy/states.dart';

class GetPolicyDataBloc extends Bloc<GetPolicyDataEvents, GetPolicyDataStates> {
  ServerGate serverGate = ServerGate();
  GetPolicyDataBloc() : super(GetPolicyDataStates());

  @override
  Stream<GetPolicyDataStates> mapEventToState(
      GetPolicyDataEvents event) async* {
    if (event is GetPolicyDataEventsStart) {
      // show loader ........ ?
      yield GetPolicyDataStatesStart();

      CustomResponse response = await getPolicyData();

      if (response.success) {
        print("response => ${response.response.data.toString()}");
        PolicyAppModel policyAppModel =
            PolicyAppModel.fromJson(response.response.data);
        yield GetPolicyDataStatesSuccess(policyData: policyAppModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetPolicyDataStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield GetPolicyDataStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetPolicyDataStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> getPolicyData() async {
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.getFromServer(
      url: "policy",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
      },
    );

    return response;
  }
}
