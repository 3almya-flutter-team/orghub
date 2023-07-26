import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/OrderDetail/DeleteOrder/events.dart';
import 'package:orghub/Screens/OrderDetail/DeleteOrder/states.dart';
import 'package:orghub/Screens/OrderDetail/model.dart';

class DeleteOrderBloc
    extends Bloc<DeleteOrderEvents, DeleteOrderStates> {
  ServerGate serverGate = ServerGate();
  DeleteOrderBloc() : super(DeleteOrderStates());

  @override
  Stream<DeleteOrderStates> mapEventToState(
      DeleteOrderEvents event) async* {
    if (event is DeleteOrderEventsStart) {
      // show loader ........ ?
      yield DeleteOrderStatesStart();

      CustomResponse response =
          await deleteOrder(orderId: event.orderId, status: event.status);

      if (response.success) {
        print("response => ${response.response.data.toString()}");
        SingleBuyingOrderModel singleBuyingOrder = SingleBuyingOrderModel();
        yield DeleteOrderStatesSuccess(
            singleBuyingOrder: singleBuyingOrder.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield DeleteOrderStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield DeleteOrderStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield DeleteOrderStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> deleteOrder({int orderId, String status}) async {
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
