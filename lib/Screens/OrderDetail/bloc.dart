import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/OrderDetail/events.dart';
import 'package:orghub/Screens/OrderDetail/model.dart';
import 'package:orghub/Screens/OrderDetail/states.dart';

class GetSingleBuyinOrder
    extends Bloc<GetSingleBuyinOrderEvents, GetSingleBuyinOrderStates> {
  ServerGate serverGate = ServerGate();
  GetSingleBuyinOrder() : super(GetSingleBuyinOrderStates());

  SingleBuyingOrderModel singleBuyingOrder;

  @override
  Stream<GetSingleBuyinOrderStates> mapEventToState(
      GetSingleBuyinOrderEvents event) async* {
    if (event is GetSingleBuyinOrderEventsStart) {
      // show loader ........ ?
      yield GetSingleBuyinOrderStatesStart();

      CustomResponse response =
          await getSingleBuyinOrder(event.orderId, event.api);

      if (response.success) {
        print("response => ${response.response.data.toString()}");
        singleBuyingOrder =
            SingleBuyingOrderModel.fromJson(response.response.data);

        yield GetSingleBuyinOrderStatesSuccess(
            singleBuyingOrder: singleBuyingOrder.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetSingleBuyinOrderStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield GetSingleBuyinOrderStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield GetSingleBuyinOrderStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    } else if (event is GetSingleBuyinOrderEventsUpdated) {
      singleBuyingOrder.data.orderStatus = event.status;
      yield GetSingleBuyinOrderStatesSuccess(
          singleBuyingOrder: singleBuyingOrder.data);
    }
  }

  Future<CustomResponse> getSingleBuyinOrder(int orderId, String api) async {
    print(orderId.toString());
    print("Bearer ${await Prefs.getStringF("authToken")}");
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.getFromServer(
      url: "client/$api/$orderId",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );

    return response;
  }
}
