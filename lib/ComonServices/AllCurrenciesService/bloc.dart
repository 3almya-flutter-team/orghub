import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/ComonServices/AllCurrenciesService/events.dart';
import 'package:orghub/ComonServices/AllCurrenciesService/model.dart';
import 'package:orghub/ComonServices/AllCurrenciesService/states.dart';
import 'package:orghub/Helpers/server_gate.dart';

class GetAllCurrenciesBloc extends Bloc<GetAllCurrenciesEvents, GetAllCurrenciesStates> {
  GetAllCurrenciesBloc() : super(GetAllCurrenciesStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetAllCurrenciesStates> mapEventToState(GetAllCurrenciesEvents event) async* {
    if (event is GetAllCurrenciesEventStart) {
      yield GetAllCurrenciesStateStart();
      CustomResponse response = await fetchAllCurrencies();
      if (response.success) {
        AllCurrenciesModel allCurrenciesModel =
            AllCurrenciesModel.fromJson(response.response.data);
        yield GetAllCurrenciesStateSucess(allCurrenciesModel: allCurrenciesModel);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllCurrenciesStateFaild(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllCurrenciesStateFaild(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield GetAllCurrenciesStateFaild(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllCurrencies({int countryId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "currencies",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
      },
    );
    return response;
  }
}
