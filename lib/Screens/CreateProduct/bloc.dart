import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/CreateProduct/events.dart';
import 'package:orghub/Screens/CreateProduct/states.dart';

class CreateNewAdvertBloc
    extends Bloc<CreateNewAdvertEvent, CreateNewAdvertStates> {
  ServerGate serverGate = ServerGate();
  CreateNewAdvertBloc() : super(CreateNewAdvertStates());

  @override
  Stream<CreateNewAdvertStates> mapEventToState(
      CreateNewAdvertEvent event) async* {
    if (event is CreateNewAdvertEventStart) {
      // show loader ........ ?
      yield CreateNewAdvertStatesStart();

      CustomResponse response = await createNewAdvert(event.advertData);

      if (response.success) {
        print("response => ${response.response.data.toString()}");

        yield CreateNewAdvertStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield CreateNewAdvertStatesFailed(
            statusCode: response.statusCode,
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield CreateNewAdvertStatesFailed(
            statusCode: response.statusCode,
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield CreateNewAdvertStatesFailed(
            statusCode: response.statusCode,
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> createNewAdvert(
      Map<String, dynamic> advertData) async {
    print(advertData.toString());
    print("Bearer ${await Prefs.getStringF("authToken")}");
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "client/ads",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
      body: advertData,
    );

    return response;
  }
}
