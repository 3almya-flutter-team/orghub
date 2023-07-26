import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/OrdersHistory/SellingOrders/model.dart';
import 'package:orghub/Screens/OrdersOnMyAds/SellingOrders/events.dart';
import 'package:orghub/Screens/OrdersOnMyAds/SellingOrders/states.dart';

class GetOrdersOnMySellingOrdersBloc extends Bloc<GetOrdersOnMySellingOrdersEvents, GetOrdersOnMySellingOrdersStates> {
  GetOrdersOnMySellingOrdersBloc() : super(GetOrdersOnMySellingOrdersStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetOrdersOnMySellingOrdersStates> mapEventToState(GetOrdersOnMySellingOrdersEvents event) async* {
    if (event is GetOrdersOnMySellingOrdersEventsStart) {
      yield GetOrdersOnMySellingOrdersStatesStart();
      CustomResponse response = await getOrdersOnMySellingOrders();
      if (response.success) {
        MySellingModel mySellingModel =
            MySellingModel.fromJson(response.response.data);
        yield GetOrdersOnMySellingOrdersStatesSuccess(mySellingOrders: mySellingModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetOrdersOnMySellingOrdersStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetOrdersOnMySellingOrdersStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield GetOrdersOnMySellingOrdersStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> getOrdersOnMySellingOrders() async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/ad_orders?order_type=sell",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
