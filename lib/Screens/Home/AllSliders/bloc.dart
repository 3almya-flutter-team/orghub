import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:orghub/ComonServices/CityService/states.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Home/AllSliders/events.dart';
import 'package:orghub/Screens/Home/AllSliders/model.dart';
import 'package:orghub/Screens/Home/AllSliders/states.dart';

class GetAllSlidersBloc extends Bloc<GetAllSlidersEvents, GetAllSlidersStates> {
  GetAllSlidersBloc() : super(GetAllSlidersStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetAllSlidersStates> mapEventToState(
      GetAllSlidersEvents event) async* {
    if (event is GetAllSlidersEventStart) {
      yield GetAllSlidersStateStart();
      CustomResponse response = await fetchAllSliders();
      if (response.success) {
        AllSlidersModel allSlidersModel =
            AllSlidersModel.fromJson(response.response.data);
        yield GetAllSlidersStateSucess(allSliders: allSlidersModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllSlidersStateFaild(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllSlidersStateFaild(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetAllSlidersStateFaild(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllSliders() async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/sliders",
      headers: {
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Accept": "application/json",
      },
    );
    return response;
  }
}
