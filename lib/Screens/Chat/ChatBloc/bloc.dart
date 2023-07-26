import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Chat/ChatBloc/events.dart';
import 'package:orghub/Screens/Chat/ChatBloc/model.dart';
import 'package:orghub/Screens/Chat/ChatBloc/states.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/model.dart';

class GetSingleChatBloc extends Bloc<GetSingleChatEvents, GetSingleChatStates> {
  GetSingleChatBloc() : super(GetSingleChatStates());
  // Completer completer = Completer();

  ServerGate serverGate = ServerGate();
  List<SendMessageData> allMessages = [];
  int chatId;

  @override
  Stream<GetSingleChatStates> mapEventToState(
      GetSingleChatEvents event) async* {
    if (event is GetSingleChatEventsStart) {
      yield GetSingleChatStatesStart();
      CustomResponse response =
          await getAllMessages(receiverId: event.receiverId);
      if (response.success) {
        SingleChatModel allChatsModel =
            SingleChatModel.fromJson(response.response.data);
        allMessages.addAll(allChatsModel.data);
        chatId = allChatsModel.chatId;
        
        yield GetSingleChatStatesSucess(
            chatId: allChatsModel.chatId, messages: allMessages);

        
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetSingleChatStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetSingleChatStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetSingleChatStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    } else if (event is GetSingleChatEventsUpdated) {
      allMessages.add(event.mssage);
      yield GetSingleChatStatesSucess(chatId: chatId, messages: allMessages);
    }
  }

  Future<CustomResponse> getAllMessages({@required int receiverId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/chats/$receiverId",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
