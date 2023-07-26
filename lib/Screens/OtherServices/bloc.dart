import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/OtherServices/events.dart';
import 'package:orghub/Screens/OtherServices/states.dart';

class SelectOtherServiceBloc
    extends Bloc<SelectOtherServiceEvent, SelectOtherServiceState> {
  ServerGate serverGate = ServerGate();
  SelectOtherServiceBloc() : super(SelectOtherServiceState());

  @override
  Stream<SelectOtherServiceState> mapEventToState(
      SelectOtherServiceEvent event) async* {
    if (event is SelectOtherServiceEventStart) {
      // show loader ........ ?
      yield SelectOtherServiceStateStart();

      CustomResponse response = await sendSelectOtherServiceData(event.service,event.orderId);

      if (response.success) {
        print("response => ${response.response.data.toString()}");

        yield SelectOtherServiceStateSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield SelectOtherServiceStateFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield SelectOtherServiceStateFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield SelectOtherServiceStateFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> sendSelectOtherServiceData(String service,int orderId) async {
    print(service.toString());

    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "client/service_requests",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
      body: {
        "service_type": service,
        "order_id": orderId,
      },
    );

    return response;
  }
}
