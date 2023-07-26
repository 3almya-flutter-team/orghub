import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/MyComments/events.dart';
import 'package:orghub/Screens/MyComments/model.dart';
import 'package:orghub/Screens/MyComments/states.dart';

class GetAllCommentsBloc extends Bloc<GetAllCommentsEvents, GetAllCommentsStates> {
  GetAllCommentsBloc() : super(GetAllCommentsStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetAllCommentsStates> mapEventToState(GetAllCommentsEvents event) async* {
    if (event is GetAllCommentsEventsStart) {
    
      yield GetAllCommentsStatesStart();
      CustomResponse response = await fetchAllComments();
      if (response.success) {
        MyCommentsModel myCommentsModel =
            MyCommentsModel.fromJson(response.response.data);
        yield GetAllCommentsStatesSuccess(myComments: myCommentsModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllCommentsStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllCommentsStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetAllCommentsStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllComments() async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "comments",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
