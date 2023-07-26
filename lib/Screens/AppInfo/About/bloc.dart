import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/AppInfo/About/events.dart';
import 'package:orghub/Screens/AppInfo/About/model.dart';
import 'package:orghub/Screens/AppInfo/About/states.dart';

class GetAboutDataBloc extends Bloc<GetAboutDataEvents, GetAboutDataStates> {
  ServerGate serverGate = ServerGate();
  GetAboutDataBloc() : super(GetAboutDataStates());

  @override
  Stream<GetAboutDataStates> mapEventToState(GetAboutDataEvents event) async* {
    if (event is GetAboutDataEventsStart) {
      // show loader ........ ?
      yield GetAboutDataStatesStart();

      CustomResponse response = await getAboutData();

      if (response.success) {
        print("response => ${response.response.data.toString()}");
        AboutAppModel aboutAppModel =
            AboutAppModel.fromJson(response.response.data);
        yield GetAboutDataStatesSuccess(aboutData: aboutAppModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAboutDataStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield GetAboutDataStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield GetAboutDataStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> getAboutData() async {
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.getFromServer(
      url: "about",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
      },
    );

    return response;
  }
}
