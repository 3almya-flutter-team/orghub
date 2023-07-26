import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/UpdateUserProfile/events.dart';
import 'package:orghub/Screens/UpdateUserProfile/model.dart';
import 'package:orghub/Screens/UpdateUserProfile/states.dart';

class GetUserProfileDataBloc
    extends Bloc<GetUserProfileEvent, GetUserProfileState> {
  GetUserProfileDataBloc() : super(GetUserProfileState());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetUserProfileState> mapEventToState(
      GetUserProfileEvent event) async* {
    if (event is GetUserProfileEventStart) {
      yield GetUserProfileStateStart();
      CustomResponse response =
          await getUserProfileData();
      if (response.success) {
        UserProfileModel profileModel =
            UserProfileModel.fromJson(response.response.data);
        yield GetUserProfileStateSuccess(userProfileModel: profileModel);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetUserProfileStateFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetUserProfileStateFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetUserProfileStateFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> getUserProfileData() async {
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