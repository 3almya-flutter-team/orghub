import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/ComonServices/AllMarksService/events.dart';
import 'package:orghub/ComonServices/AllMarksService/model.dart';
import 'package:orghub/ComonServices/AllMarksService/states.dart';
import 'package:orghub/Helpers/server_gate.dart';

class GetAllMarksBloc extends Bloc<GetAllMarksEvents, GetAllMarksStates> {
  GetAllMarksBloc() : super(GetAllMarksStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetAllMarksStates> mapEventToState(GetAllMarksEvents event) async* {
    if (event is GetAllMarksEventStart) {
      yield GetAllMarksStateStart();
      CustomResponse response = await fetchAllMarks();
      if (response.success) {
        AllMarksModel allMarksModel =
            AllMarksModel.fromJson(response.response.data);
        yield GetAllMarksStateSucess(allMarksModel: allMarksModel);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllMarksStateFaild(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllMarksStateFaild(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield GetAllMarksStateFaild(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllMarks({int countryId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "marks",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
      },
    );
    return response;
  }
}
