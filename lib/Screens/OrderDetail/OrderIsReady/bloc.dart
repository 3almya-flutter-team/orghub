import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/OrderDetail/OrderIsReady/events.dart';
import 'package:orghub/Screens/OrderDetail/OrderIsReady/states.dart';
import 'package:orghub/Screens/OrderDetail/model.dart';

class ChangeOrderStatusBloc
    extends Bloc<ChangeOrderStatusEvents, ChangeOrderStatusStates> {
  ServerGate serverGate = ServerGate();
  ChangeOrderStatusBloc() : super(ChangeOrderStatusStates());

  @override
  Stream<ChangeOrderStatusStates> mapEventToState(
      ChangeOrderStatusEvents event) async* {
    if (event is ChangeOrderStatusEventsStart) {
      // show loader ........ ?
      yield ChangeOrderStatusStatesStart();

      CustomResponse response =
          await changeOrderStatus(orderId: event.orderId, status: event.status);

      if (response.success) {
        print("response => ${response.response.data.toString()}");
        SingleBuyingOrderModel singleBuyingOrder = SingleBuyingOrderModel();
        yield ChangeOrderStatusStatesSuccess(
            singleBuyingOrder: singleBuyingOrder.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield ChangeOrderStatusStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield ChangeOrderStatusStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield ChangeOrderStatusStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> changeOrderStatus({int orderId, String status}) async {
    print("Bearer ${await Prefs.getStringF("authToken")}");
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "client/order_status/$orderId",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
      body: {
        "order_status": status,
      },
    );

    return response;
  }
}
