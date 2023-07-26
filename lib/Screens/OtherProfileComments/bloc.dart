import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/OtherProfileComments/events.dart';
import 'package:orghub/Screens/OtherProfileComments/model.dart';
import 'package:orghub/Screens/OtherProfileComments/states.dart';

class GetAllCompanyCommentsBloc extends Bloc<GetAllCompanyCommentsEvents, GetAllCompanyCommentsStates> {
  GetAllCompanyCommentsBloc() : super(GetAllCompanyCommentsStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetAllCompanyCommentsStates> mapEventToState(GetAllCompanyCommentsEvents event) async* {
    if (event is GetAllCompanyCommentsEventsStart) {
    
      yield GetAllCompanyCommentsStatesStart();
      var fetchAllCompanyComments2 = fetchAllCompanyComments(companyId: event.companyId);
      CustomResponse response = await fetchAllCompanyComments2;
      if (response.success) {
        CompanyCommentsModel companyCommentsModel =
            CompanyCommentsModel.fromJson(response.response.data);
        yield GetAllCompanyCommentsStatesSuccess(allComments: companyCommentsModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllCompanyCommentsStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllCompanyCommentsStatesFailed(
            errType: 1,
             statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetAllCompanyCommentsStatesFailed(
            errType: 2,
             statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllCompanyComments({@required int companyId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/$companyId/comments",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
