import 'package:flutter/material.dart';
import 'package:orghub/ComonServices/GetAllRecursionCats/model.dart';

class GetAllRecursionCategoriesStates {}

class GetAllRecursionCategoriesStateStart extends GetAllRecursionCategoriesStates {}

class GetAllRecursionCategoriesStateSucess extends GetAllRecursionCategoriesStates {
  List<CatData> allRecursionCategories;
  GetAllRecursionCategoriesStateSucess({
    @required this.allRecursionCategories,
  });
}

class GetAllRecursionCategoriesStateFaild extends GetAllRecursionCategoriesStates {
  String msg;
  int errType;
  GetAllRecursionCategoriesStateFaild({this.msg, this.errType});
}
