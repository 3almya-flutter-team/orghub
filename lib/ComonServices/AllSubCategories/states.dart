import 'package:flutter/material.dart';
import 'package:orghub/Screens/Home/AllCategories/model.dart';

class GetAllSubCategoriesStates {}

class GetAllSubCategoriesStateStart extends GetAllSubCategoriesStates {}

class GetAllSubCategoriesStateSucess extends GetAllSubCategoriesStates {
  List<CategoryData> allSubCategories;
  GetAllSubCategoriesStateSucess({
    @required this.allSubCategories,
  });
}

class GetAllSubCategoriesStateFaild extends GetAllSubCategoriesStates {
  String msg;
  int errType;
  dynamic statusCode;
  GetAllSubCategoriesStateFaild({this.msg, this.errType,this.statusCode});
}
