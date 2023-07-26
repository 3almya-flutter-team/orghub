import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/OrdersHistory/BuyingOrders/model.dart';
import 'package:orghub/Screens/OrdersOnMyAds/BuyingOrders/events.dart';
import 'package:orghub/Screens/OrdersOnMyAds/BuyingOrders/states.dart';

class GetOrdersOnMyAdsBloc extends Bloc<GetOrdersOnMyAdsEvents, GetOrdersOnMyAdsStates> {
  GetOrdersOnMyAdsBloc() : super(GetOrdersOnMyAdsStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetOrdersOnMyAdsStates> mapEventToState(GetOrdersOnMyAdsEvents event) async* {
    if (event is GetOrdersOnMyAdsEventsStart) {
      yield GetOrdersOnMyAdsStatesStart();
      CustomResponse response = await getOrdersOnMyAds();
      if (response.success) {
        MyOrdersModel myOrdersModel =
            MyOrdersModel.fromJson(response.response.data);
        yield GetOrdersOnMyAdsStatesSuccess(myOrders: myOrdersModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetOrdersOnMyAdsStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetOrdersOnMyAdsStatesFailed(
            errType: 1,
             statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetOrdersOnMyAdsStatesFailed(
            errType: 2,
             statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> getOrdersOnMyAds() async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/ad_orders?order_type=buy",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
        // "Authorization":
        //     "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9sb2NhbGhvc3Q6ODAwMFwvYXBpXC9sb2dpbiIsImlhdCI6MTU5NTUwODgzOSwiZXhwIjoxNjI3MDQ0ODM5LCJuYmYiOjE1OTU1MDg4MzksImp0aSI6IjhCM3h1ZDJsN21NVXNMeFEiLCJzdWIiOjMsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.tPSUVu4K91n28mqfDL_4orA1JoyXjJghIIsTigFCQeU",
      },
    );
    return response;
  }
}
