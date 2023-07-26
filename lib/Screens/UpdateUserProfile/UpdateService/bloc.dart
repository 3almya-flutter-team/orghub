import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/UpdateUserProfile/UpdateService/events.dart';
import 'package:orghub/Screens/UpdateUserProfile/UpdateService/states.dart';

class UserProfileUpdateBloc
    extends Bloc<UserProfileUpdateEvents, UserProfileUpdateStates> {
  ServerGate serverGate = ServerGate();
  UserProfileUpdateBloc() : super(UserProfileUpdateStates());

  @override
  Stream<UserProfileUpdateStates> mapEventToState(
      UserProfileUpdateEvents event) async* {
    if (event is UserProfileUpdateEventStart) {
      print("111111");
      // show loader ........ ?
      yield UserProfileUpdateStateStart();
      print("222222");
      // Send UserProfileData to server via Register Api
      CustomResponse response = await updateUserProfileProfile(event.userData);

      if (response.success) {
        // UserProfileRegisterStateSuccess
        print("response => ${response.response.data.toString()}");
        // GO TO ACTIVATION PAGE ->
        yield UserProfileUpdateStateSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield UserProfileUpdateStateFailed(
            statusCode: response.statusCode,
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield UserProfileUpdateStateFailed(
            statusCode: response.statusCode,
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield UserProfileUpdateStateFailed(
            statusCode: response.statusCode,
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> updateUserProfileProfile(
      Map<String, dynamic> userProfileData) async {
    print("=-=-=-= client data updated =-=-=-= ${userProfileData.toString()}");

    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
        url: "profile",
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
        },
        body: userProfileData);

    return response;
  }
}
