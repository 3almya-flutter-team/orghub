import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/ComonServices/GetUserType/events.dart';
import 'package:orghub/ComonServices/GetUserType/states.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Screens/UpdateUserProfile/states.dart';

class GetUserTypeBloc extends Bloc {
  GetUserTypeBloc() : super(GetUserProfileState());

  @override
  Stream mapEventToState(event) async* {
    if (event is GetUserTypeEventsStart) {
      String type = await getUserType();
      yield GetUserTypeStatesSuccess(type: type);
    }
  }

  Future<String> getUserType() async {
    return await Prefs.getStringF("userType");
  }
}
