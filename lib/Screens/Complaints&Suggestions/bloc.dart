import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Complaints&Suggestions/events.dart';
import 'package:orghub/Screens/Complaints&Suggestions/states.dart';

class ContactBloc extends Bloc<ContactEvents, ContactStates> {
  ServerGate serverGate = ServerGate();
  ContactBloc() : super(ContactStates());

  @override
  Stream<ContactStates> mapEventToState(ContactEvents event) async* {
    if (event is ContactEventsStart) {
      // show loader ........ ?
      yield ContactStatesStart();

      CustomResponse response = await sendContactData(event.contactData,event.type);

      if (response.success) {
        print("response => ${response.response.data.toString()}");

        yield ContactStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield ContactStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield ContactStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield ContactStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> sendContactData(
      Map<String, dynamic> contactData, String type) async {
    print(contactData.toString());

    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "contact",
      headers: type == 'auth'
          ? {
              "Accept": "application/json",
              "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
            }
          : {
              "Accept": "application/json",
            },
      body: contactData,
    );

    return response;
  }
}
