import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/ProductOrder/events.dart';
import 'package:orghub/Screens/ProductOrder/states.dart';
// import 'package:orghub/Screens/ProductOrder/view.dart';

class MakeNewOrderBloc extends Bloc<MakeNewOrderEvents, MakeNewOrderStates> {
  ServerGate serverGate = ServerGate();
  MakeNewOrderBloc() : super(MakeNewOrderStates());

  @override
  Stream<MakeNewOrderStates> mapEventToState(MakeNewOrderEvents event) async* {
    if (event is MakeNewOrderEventsStart) {
      // show loader ........ ?
      yield MakeNewOrderStatesStart();

      CustomResponse response = await makeNewOrder(event.orderData);

      if (response.success) {
        print("response => ${response.response.data.toString()}");

        yield MakeNewOrderStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield MakeNewOrderStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield MakeNewOrderStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield MakeNewOrderStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> makeNewOrder(Map<String,dynamic> orderData) async {
    print(orderData.toString());
    print("Bearer ${await Prefs.getStringF("authToken")}");
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "client/orders",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
      body: orderData,
      // body: {
      //   "country_id": orderData.countryId,
      //   "city_id": orderData.cityId,
      //   "ad_id": orderData.adId,
      //   "address": orderData.address,
      //   "qty": orderData.qty,
      // },
    );

    return response;
  }
}
