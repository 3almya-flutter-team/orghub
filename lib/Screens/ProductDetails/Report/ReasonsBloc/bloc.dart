import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/ProductDetails/Report/ReasonsBloc/events.dart';
import 'package:orghub/Screens/ProductDetails/Report/ReasonsBloc/model.dart';
import 'package:orghub/Screens/ProductDetails/Report/ReasonsBloc/states.dart';

class GetReportReasonsBloc extends Bloc<GetReportReasonsEvents, GetReportReasonsStates> {
  ServerGate serverGate = ServerGate();
  GetReportReasonsBloc() : super(GetReportReasonsStates());

  @override
  Stream<GetReportReasonsStates> mapEventToState(GetReportReasonsEvents event) async* {
    if (event is GetReportReasonsEventsStart) {
      // show loader ........ ?
      yield GetReportReasonsStatesStart();

      CustomResponse response = await getReportReasons();

      if (response.success) {
        print("response => ${response.response.data.toString()}");
        ReasonsModel reasonsModel =
            ReasonsModel.fromJson(response.response.data);
        yield GetReportReasonsStatesSuccess(reasons: reasonsModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetReportReasonsStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield GetReportReasonsStatesFailed(
            errType: 1,
             statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetReportReasonsStatesFailed(
            errType: 2,
             statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> getReportReasons() async {
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.getFromServer(
      url: "client/reasons/report",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );

    return response;
  }
}
