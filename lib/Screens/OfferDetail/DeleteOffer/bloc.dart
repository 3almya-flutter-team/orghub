import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/OfferDetail/DeleteOffer/events.dart';
import 'package:orghub/Screens/OfferDetail/DeleteOffer/states.dart';

class DeleteOfferBloc extends Bloc<DeleteOfferEvents, DeleteOfferStates> {
  ServerGate serverGate = ServerGate();
  DeleteOfferBloc() : super(DeleteOfferStates());

  @override
  Stream<DeleteOfferStates> mapEventToState(DeleteOfferEvents event) async* {
    if (event is DeleteOfferEventsStart) {
      // show loader ........ ?
      yield DeleteOfferStatesStart();

      CustomResponse response = await deleteOffer(offerId: event.offerId);

      if (response.success) {
        print("response => ${response.response.data.toString()}");

        yield DeleteOfferStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield DeleteOfferStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield DeleteOfferStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield DeleteOfferStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> deleteOffer({int offerId}) async {
    serverGate.addInterceptors();
    CustomResponse response = await serverGate
        .sendToServer(url: "client/ad_offers/$offerId", headers: {
      "Delete": "application/json",
      "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
    }, body: {
      "_method": "delete",
    });

    return response;
  }
}
