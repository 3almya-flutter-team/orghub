import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/ComonServices/AllSubCategories/events.dart';
import 'package:orghub/ComonServices/AllSubCategories/states.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Home/AllCategories/model.dart';

class GetAllSubCategoriesBloc
    extends Bloc<GetAllSubCategoriesEvents, GetAllSubCategoriesStates> {
  GetAllSubCategoriesBloc() : super(GetAllSubCategoriesStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetAllSubCategoriesStates> mapEventToState(
      GetAllSubCategoriesEvents event) async* {
    if (event is GetAllSubCategoriesEventStart) {
      yield GetAllSubCategoriesStateStart();
      CustomResponse response = await fetchAllSubCategories(catId: event.catId);
      if (response.success) {
        AllCategoriesModel allCategoriesModel =
            AllCategoriesModel.fromJson(response.response.data);
        yield GetAllSubCategoriesStateSucess(
            allSubCategories: allCategoriesModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllSubCategoriesStateFaild(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllSubCategoriesStateFaild(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetAllSubCategoriesStateFaild(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllSubCategories({int catId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "categories/$catId/subcategories",
      headers: {
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Accept": "application/json",
      },
    );
    return response;
  }
}
