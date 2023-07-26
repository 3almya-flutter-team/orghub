import 'package:flutter/foundation.dart';

class GetAllSubCategoriesEvents {}

class GetAllSubCategoriesEventStart extends GetAllSubCategoriesEvents {
  int catId;
  GetAllSubCategoriesEventStart({
    @required this.catId,
  });
}

class GetAllSubCategoriesEventSucess extends GetAllSubCategoriesEvents {}

class GetAllCategoriesEventFaild extends GetAllSubCategoriesEvents {}
