import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/OrdersHistory/BuyingOrders/events.dart';
import 'package:orghub/Screens/OrdersHistory/BuyingOrders/model.dart';
import 'package:orghub/Screens/OrdersHistory/BuyingOrders/states.dart';

class GetMyOrdersBloc extends Bloc<GetMyOrdersEvents, GetMyOrdersStates> {
  GetMyOrdersBloc() : super(GetMyOrdersStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetMyOrdersStates> mapEventToState(GetMyOrdersEvents event) async* {
    if (event is GetMyOrdersEventsStart) {
      yield GetMyOrdersStatesStart();
      CustomResponse response = await getMyOrders();
      if (response.success) {
        MyOrdersModel myOrdersModel =
            MyOrdersModel.fromJson(response.response.data);
        yield GetMyOrdersStatesSuccess(myOrders: myOrdersModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetMyOrdersStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetMyOrdersStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetMyOrdersStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> getMyOrders() async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/orders?order_type=buy",
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
