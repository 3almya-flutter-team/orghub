import 'package:orghub/ComonServices/CityService/model.dart';

class GetAllCitesStates {}

class GetAllCitesStateStart extends GetAllCitesStates {}

class GetAllCitesStateSucess extends GetAllCitesStates {
  AllCitiesModel allCitiesModel;
  GetAllCitesStateSucess({
    this.allCitiesModel,
  });
}

class GetAllCitesStateFaild extends GetAllCitesStates {
  String msg;
  dynamic statusCode;
  int errType;
  GetAllCitesStateFaild({this.msg, this.errType,this.statusCode});
}
