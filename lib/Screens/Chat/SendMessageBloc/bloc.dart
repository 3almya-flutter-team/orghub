import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/events.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/model.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/states.dart';

class SendMessageBloc extends Bloc<SendMessageEvents, SendMessageStates> {
  SendMessageBloc() : super(SendMessageStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<SendMessageStates> mapEventToState(SendMessageEvents event) async* {
    if (event is SendMessageEventsStart) {
      yield SendMessageStatesStart();
      CustomResponse response = await sendMessage(
          receiverId: event.receiverId,
          message: event.message,
          messageType: event.messageType);
      if (response.success) {
        SendMessageModel message = SendMessageModel.fromJson(response.response.data);
        yield SendMessageStatesSuccess(message: message);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield SendMessageStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield SendMessageStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield SendMessageStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> sendMessage({
    @required int receiverId,
    @required dynamic message,
    @required String messageType,
  }) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.sendToServer(
      url: "client/chats",
      body: {
        "receiver_id": receiverId,
        "message": message,
        "message_type": messageType,
      },
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
