import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/OrdersHistory/SellingOrders/events.dart';
import 'package:orghub/Screens/OrdersHistory/SellingOrders/model.dart';
import 'package:orghub/Screens/OrdersHistory/SellingOrders/states.dart';

class GetMySellingOrdersBloc extends Bloc<GetMySellingOrdersEvents, GetMySellingOrdersStates> {
  GetMySellingOrdersBloc() : super(GetMySellingOrdersStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetMySellingOrdersStates> mapEventToState(GetMySellingOrdersEvents event) async* {
    if (event is GetMySellingOrdersEventsStart) {
      yield GetMySellingOrdersStatesStart();
      CustomResponse response = await getMySellingOrders();
      if (response.success) {
        MySellingModel mySellingModel =
            MySellingModel.fromJson(response.response.data);
        yield GetMySellingOrdersStatesSuccess(mySellingOrders: mySellingModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetMySellingOrdersStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetMySellingOrdersStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetMySellingOrdersStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> getMySellingOrders() async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/orders?order_type=sell",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
        // "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9sb2NhbGhvc3Q6ODAwMFwvYXBpXC9sb2dpbiIsImlhdCI6MTU5NTUwODgzOSwiZXhwIjoxNjI3MDQ0ODM5LCJuYmYiOjE1OTU1MDg4MzksImp0aSI6IjhCM3h1ZDJsN21NVXNMeFEiLCJzdWIiOjMsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.tPSUVu4K91n28mqfDL_4orA1JoyXjJghIIsTigFCQeU",
      },
    );
    return response;
  }
}
