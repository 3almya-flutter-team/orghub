import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/OrderDetail/OwnerRefuseOrder/events.dart';
import 'package:orghub/Screens/OrderDetail/OwnerRefuseOrder/states.dart';
import 'package:orghub/Screens/OrderDetail/model.dart';

class OwnerRefuseOrderBloc
    extends Bloc<OwnerRefuseOrderEvents, OwnerRefuseOrderStates> {
  ServerGate serverGate = ServerGate();
  OwnerRefuseOrderBloc() : super(OwnerRefuseOrderStates());

  @override
  Stream<OwnerRefuseOrderStates> mapEventToState(
      OwnerRefuseOrderEvents event) async* {
    if (event is OwnerRefuseOrderEventsStart) {
      // show loader ........ ?
      yield OwnerRefuseOrderStatesStart();

      CustomResponse response =
          await ownerRefuseOrder(orderId: event.orderId, status: event.status);

      if (response.success) {
        print("response => ${response.response.data.toString()}");
        SingleBuyingOrderModel singleBuyingOrder = SingleBuyingOrderModel();
        yield OwnerRefuseOrderStatesSuccess(
            singleBuyingOrder: singleBuyingOrder.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield OwnerRefuseOrderStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield OwnerRefuseOrderStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield OwnerRefuseOrderStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> ownerRefuseOrder({int orderId, String status}) async {
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
