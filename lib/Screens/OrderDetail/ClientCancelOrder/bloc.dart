import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/OrderDetail/ClientCancelOrder/events.dart';
import 'package:orghub/Screens/OrderDetail/ClientCancelOrder/states.dart';
import 'package:orghub/Screens/OrderDetail/model.dart';

class ClientCancelOrderBloc
    extends Bloc<ClientCancelOrderEvents, ClientCancelOrderStates> {
  ServerGate serverGate = ServerGate();
  ClientCancelOrderBloc() : super(ClientCancelOrderStates());

  @override
  Stream<ClientCancelOrderStates> mapEventToState(
      ClientCancelOrderEvents event) async* {
    if (event is ClientCancelOrderEventsStart) {
      // show loader ........ ?
      yield ClientCancelOrderStatesStart();

      CustomResponse response =
          await clientCancelOrder(orderId: event.orderId, status: event.status);

      if (response.success) {
        print("response => ${response.response.data.toString()}");
        SingleBuyingOrderModel singleBuyingOrder = SingleBuyingOrderModel();
        yield ClientCancelOrderStatesSuccess(
            singleBuyingOrder: singleBuyingOrder.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield ClientCancelOrderStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield ClientCancelOrderStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield ClientCancelOrderStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> clientCancelOrder({int orderId, String status}) async {
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
