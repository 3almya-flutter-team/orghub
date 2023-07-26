import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/ComonServices/AllClassificationsService/events.dart';
import 'package:orghub/ComonServices/AllClassificationsService/model.dart';
import 'package:orghub/ComonServices/AllClassificationsService/states.dart';
import 'package:orghub/Helpers/server_gate.dart';

class GetAllClassificationsBloc extends Bloc<GetAllClassificationsEvents, GetAllClassificationsStates> {
  GetAllClassificationsBloc() : super(GetAllClassificationsStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetAllClassificationsStates> mapEventToState(GetAllClassificationsEvents event) async* {
    if (event is GetAllClassificationsEventStart) {
      yield GetAllClassificationsStateStart();
      CustomResponse response = await fetchAllClassifications();
      if (response.success) {
        AllClassificationsModel allClassificationsModel =
            AllClassificationsModel.fromJson(response.response.data);
        yield GetAllClassificationsStateSucess(allClassificationsModel: allClassificationsModel);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllClassificationsStateFaild(
            errType: 0,
            msg: "Network error ",
            statusCode: response.statusCode,
          );
        } else if (response.errType == 1) {
          yield GetAllClassificationsStateFaild(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetAllClassificationsStateFaild(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllClassifications({int countryId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "classifications",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
      },
    );
    return response;
  }
}
