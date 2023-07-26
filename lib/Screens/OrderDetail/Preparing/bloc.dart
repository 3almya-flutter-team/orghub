import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/OrderDetail/Preparing/events.dart';
import 'package:orghub/Screens/OrderDetail/Preparing/states.dart';
import 'package:orghub/Screens/OrderDetail/model.dart';

class PreparingOrderBloc
    extends Bloc<PreparingOrderEvents, PreparingOrderStates> {
  ServerGate serverGate = ServerGate();
  PreparingOrderBloc() : super(PreparingOrderStates());

  @override
  Stream<PreparingOrderStates> mapEventToState(
      PreparingOrderEvents event) async* {
    if (event is PreparingOrderEventsStart) {
      // show loader ........ ?
      yield PreparingOrderStatesStart();

      CustomResponse response =
          await preparingOrder(orderId: event.orderId, status: event.status);

      if (response.success) {
        print("response => ${response.response.data.toString()}");
        SingleBuyingOrderModel singleBuyingOrder = SingleBuyingOrderModel();
        yield PreparingOrderStatesSuccess(
            singleBuyingOrder: singleBuyingOrder.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield PreparingOrderStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield PreparingOrderStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield PreparingOrderStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> preparingOrder({int orderId, String status}) async {
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
