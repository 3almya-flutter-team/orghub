import 'package:flutter/material.dart';
import 'package:orghub/Screens/Home/AllCategories/model.dart';

class GetAllCategoriesStates {}

class GetAllCategoriesStateStart extends GetAllCategoriesStates {}

class GetAllCategoriesStateSucess extends GetAllCategoriesStates {
  List<CategoryData> allCategories;
  GetAllCategoriesStateSucess({
    @required this.allCategories,
  });
}

class GetAllCategoriesStateFaild extends GetAllCategoriesStates {
  String msg;
  dynamic statusCode;
  int errType;
  GetAllCategoriesStateFaild({this.msg, this.errType,this.statusCode});
}
