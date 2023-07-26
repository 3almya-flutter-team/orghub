import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Profile/events.dart';
import 'package:orghub/Screens/Profile/model.dart';
import 'package:orghub/Screens/Profile/states.dart';

class GetProfileDataBloc extends Bloc<GetProfileEvent, GetProfileState> {
  GetProfileDataBloc() : super(GetProfileState());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetProfileState> mapEventToState(GetProfileEvent event) async* {
    if (event is GetProfileEventStart) {
      yield GetProfileStateStart();
      CustomResponse response = await getProfileData();
      if (response.success) {
        ProfileModel profileModel =
            ProfileModel.fromJson(response.response.data);
        yield GetProfileStateSuccess(profileModel: profileModel);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetProfileStateFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetProfileStateFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield GetProfileStateFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> getProfileData() async {
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
