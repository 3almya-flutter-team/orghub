import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/ComonServices/CityService/events.dart';
import 'package:orghub/ComonServices/CityService/model.dart';
import 'package:orghub/ComonServices/CityService/states.dart';
import 'package:orghub/Helpers/server_gate.dart';

class GetAllCitiesBloc extends Bloc<GetAllCitiesEvents, GetAllCitesStates> {
  GetAllCitiesBloc() : super(GetAllCitesStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetAllCitesStates> mapEventToState(GetAllCitiesEvents event) async* {
    if (event is GetAllCitiesEventStart) {
      yield GetAllCitesStateStart();
      CustomResponse response = await fetchAllCites(countryId: event.countryId);
      if (response.success) {
        AllCitiesModel allCitiesModel =
            AllCitiesModel.fromJson(response.response.data);
        yield GetAllCitesStateSucess(allCitiesModel: allCitiesModel);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllCitesStateFaild(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllCitesStateFaild(
            errType: 1,
             statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetAllCitesStateFaild(
            errType: 2,
             statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllCites({int countryId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "cities/$countryId",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
      },
    );
    return response;
  }
}
