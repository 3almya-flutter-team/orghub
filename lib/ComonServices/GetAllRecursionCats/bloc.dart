import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/ComonServices/GetAllRecursionCats/events.dart';
import 'package:orghub/ComonServices/GetAllRecursionCats/model.dart';
import 'package:orghub/ComonServices/GetAllRecursionCats/states.dart';
import 'package:orghub/Helpers/server_gate.dart';

class GetAllRecursionCategoriesBloc extends Bloc<
    GetAllRecursionCategoriesEvents, GetAllRecursionCategoriesStates> {
  GetAllRecursionCategoriesBloc() : super(GetAllRecursionCategoriesStates());

  ServerGate serverGate = ServerGate();

  List<CatData> allCats = [];

  @override
  Stream<GetAllRecursionCategoriesStates> mapEventToState(
      GetAllRecursionCategoriesEvents event) async* {
    if (event is GetAllRecursionCategoriesEventStart) {
      yield GetAllRecursionCategoriesStateStart();
      CustomResponse response = await fetchAllRecursionCategories();
      if (response.success) {
        AllRecursionCategoriesModel allCategoriesModel =
            AllRecursionCategoriesModel.fromJson(response.response.data);
        getHirearchy(allCategoriesModel.data, '');
        allCats.forEach((element) {
          print(element.name);
        });
        yield GetAllRecursionCategoriesStateSucess(
            allRecursionCategories: allCats);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllRecursionCategoriesStateFaild(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllRecursionCategoriesStateFaild(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield GetAllRecursionCategoriesStateFaild(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllRecursionCategories() async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "recursion_categories",
      headers: {
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Accept": "application/json",
      },
    );
    return response;
  }

  void getHirearchy(List<CatData> subCats, String dashes) {
    subCats.forEach((cat) {
      allCats.add(
        CatData(
            id: cat.id,
            name: "$dashes ${cat.name}",
            image: cat.image,
            hasSubcategories: cat.hasSubcategories,
            subcategories: cat.subcategories,
          )
      );
      if (cat.hasSubcategories) {
        String newDashes;
        newDashes = dashes + '-';
        getHirearchy(cat.subcategories, newDashes);
      }
    });
  }
}

// $list_categories = [];
// function getHirearchy($categories,$dashes = '')
// {
//     foreach ($categories as $category){
//         $list_categories[] = $dashes.$category->name;
//         if($category->subcategories->count()){
//             $newDashes = $dashes . '-';
//             getHirearchy($category->subcategories,$newDashes);
//         }
//     }
// }
