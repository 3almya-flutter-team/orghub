import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/ComonServices/AllSpecificationsService/events.dart';
import 'package:orghub/ComonServices/AllSpecificationsService/model.dart';
import 'package:orghub/ComonServices/AllSpecificationsService/states.dart';
import 'package:orghub/Helpers/server_gate.dart';

class GetAllSpecificationsBloc extends Bloc<GetAllSpecificationsEvents, GetAllSpecificationsStates> {
  GetAllSpecificationsBloc() : super(GetAllSpecificationsStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetAllSpecificationsStates> mapEventToState(GetAllSpecificationsEvents event) async* {
    if (event is GetAllSpecificationsEventStart) {
      yield GetAllSpecificationsStateStart();
      CustomResponse response = await fetchAllSpecifications();
      if (response.success) {
        AllSpecificationsModel allSpecificationsModel =
            AllSpecificationsModel.fromJson(response.response.data);
        yield GetAllSpecificationsStateSucess(allSpecificationsModel: allSpecificationsModel);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllSpecificationsStateFaild(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllSpecificationsStateFaild(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield GetAllSpecificationsStateFaild(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllSpecifications({int countryId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "specifications",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
      },
    );
    return response;
  }
}
