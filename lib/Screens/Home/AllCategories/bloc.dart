import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Home/AllCategories/events.dart';
import 'package:orghub/Screens/Home/AllCategories/model.dart';
import 'package:orghub/Screens/Home/AllCategories/states.dart';

class GetAllCategoriesBloc extends Bloc<GetAllCategoriesEvents, GetAllCategoriesStates> {
  GetAllCategoriesBloc() : super(GetAllCategoriesStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetAllCategoriesStates> mapEventToState(GetAllCategoriesEvents event) async* {
    if (event is GetAllCategoriesEventStart) {
      yield GetAllCategoriesStateStart();
      CustomResponse response = await fetchAllCategories();
      if (response.success) {
        AllCategoriesModel allCategoriesModel =
            AllCategoriesModel.fromJson(response.response.data);
        yield GetAllCategoriesStateSucess(allCategories: allCategoriesModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllCategoriesStateFaild(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllCategoriesStateFaild(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetAllCategoriesStateFaild(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllCategories() async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "categories",
      headers: {
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Accept": "application/json",
      },
    );
    return response;
  }
}
