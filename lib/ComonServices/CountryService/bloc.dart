import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/ComonServices/CountryService/events.dart';
import 'package:orghub/ComonServices/CountryService/model.dart';
import 'package:orghub/ComonServices/CountryService/states.dart';
import 'package:orghub/Helpers/server_gate.dart';

class GetAllCountries
    extends Bloc<GetAllCountriesEvents, GetAllCountriesStates> {
  GetAllCountries() : super(GetAllCountriesStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetAllCountriesStates> mapEventToState(
      GetAllCountriesEvents event) async* {
    if (event is GetAllCountriesEventStart) {
      yield GetAllCountriesStateStart();
    }
    CustomResponse response = await fetchAllCountries();
    if (response.success) {
      AllCountriesModel allCoutries =
          AllCountriesModel.fromJson(response.response.data);
      yield GetAllCountriesStateSucess(allCountriesModel: allCoutries);
    } else {
      print("from map event to state show error => ");
      print(response.error.toString());

      if (response.errType == 0) {
        yield GetAllCountriesStateFaild(
          errType: 0,
          msg: "Network error ",
        );
      } else if (response.errType == 1) {
        yield GetAllCountriesStateFaild(
          errType: 1,
          msg: response.error['message'],
        );
      } else {
        yield GetAllCountriesStateFaild(
          errType: 2,
          msg: "Server error , please try again",
        );
      }
    }
  }

  Future<CustomResponse> fetchAllCountries() async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "countries",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
      },
    );
    return response;
  }
}
