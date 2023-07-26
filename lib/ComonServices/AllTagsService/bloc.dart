import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/ComonServices/AllTagsService/events.dart';
import 'package:orghub/ComonServices/AllTagsService/model.dart';
import 'package:orghub/ComonServices/AllTagsService/states.dart';
import 'package:orghub/Helpers/server_gate.dart';

class GetAllTagsBloc extends Bloc<GetAllTagsEvents, GetAllTagsStates> {
  GetAllTagsBloc() : super(GetAllTagsStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetAllTagsStates> mapEventToState(GetAllTagsEvents event) async* {
    if (event is GetAllTagsEventStart) {
      yield GetAllTagsStateStart();
      CustomResponse response = await fetchAllTags();
      if (response.success) {
        AllTagsModel allTagsModel =
            AllTagsModel.fromJson(response.response.data);
        yield GetAllTagsStateSucess(allTagsModel: allTagsModel);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllTagsStateFaild(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllTagsStateFaild(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetAllTagsStateFaild(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllTags({int countryId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "tags",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
      },
    );
    return response;
  }
}
