import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/ProductDetails/Report/events.dart';
import 'package:orghub/Screens/ProductDetails/Report/states.dart';

class SendReportBloc extends Bloc<SendReportEvents, SendReportStates> {
  ServerGate serverGate = ServerGate();
  SendReportBloc() : super(SendReportStates());

  @override
  Stream<SendReportStates> mapEventToState(SendReportEvents event) async* {
    if (event is SendReportEventsStart) {
      // show loader ........ ?
      yield SendReportStatesStart();

      CustomResponse response = await sendReportData(
          reasonId: event.reasonId,
          advertId: event.advertId,
          message: event.msg);

      if (response.success) {
        print("response => ${response.response.data.toString()}");

        yield SendReportStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield SendReportStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield SendReportStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield SendReportStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> sendReportData({
    @required int reasonId,
    @required int advertId,
    @required String message,
  }) async {
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "client/reports",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
      body: {
        "report_reason_id": reasonId,
        "ad_id": advertId,
        "message": message,
      },
    );

    return response;
  }
}
