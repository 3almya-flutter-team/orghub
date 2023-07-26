import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Conversations/Delete/events.dart';
import 'package:orghub/Screens/Conversations/Delete/states.dart';

class ChatsDeleteBloc extends Bloc<ChatsDeleteEvents, ChatsDeleteStates> {
  ChatsDeleteBloc() : super(ChatsDeleteStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<ChatsDeleteStates> mapEventToState(ChatsDeleteEvents event) async* {
    if (event is ChatsDeleteEventsStart) {
      yield ChatsDeleteStatesStart();
      CustomResponse response = await deleteChat(chatId: event.chatId);
      if (response.success) {
        yield ChatsDeleteStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield ChatsDeleteStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield ChatsDeleteStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield ChatsDeleteStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> deleteChat({int chatId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.sendToServer(
      url: "client/chats/$chatId",
      body: {
        "_method":"delete",
      },
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
