import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/OfferDetail/AcceptOffer/events.dart';
import 'package:orghub/Screens/OfferDetail/AcceptOffer/states.dart';

class AcceptOfferBloc extends Bloc<AcceptOfferEvents, AcceptOfferStates> {
  ServerGate serverGate = ServerGate();
  AcceptOfferBloc() : super(AcceptOfferStates());

  @override
  Stream<AcceptOfferStates> mapEventToState(AcceptOfferEvents event) async* {
    if (event is AcceptOfferEventsStart) {
      // show loader ........ ?
      yield AcceptOfferStatesStart();

      CustomResponse response = await acceptOffer(offerId: event.offerId);

      if (response.success) {
        print("response => ${response.response.data.toString()}");

        yield AcceptOfferStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield AcceptOfferStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield AcceptOfferStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield AcceptOfferStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> acceptOffer({int offerId}) async {
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "client/accept_offer/$offerId",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );

    return response;
  }
}
