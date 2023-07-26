import 'package:orghub/ComonServices/AllSpecificationsService/model.dart';

class GetAllSpecificationsStates {}

class GetAllSpecificationsStateStart extends GetAllSpecificationsStates {}

class GetAllSpecificationsStateSucess extends GetAllSpecificationsStates {
  AllSpecificationsModel allSpecificationsModel;
  GetAllSpecificationsStateSucess({
    this.allSpecificationsModel,
  });
}

class GetAllSpecificationsStateFaild extends GetAllSpecificationsStates {
  String msg;
  int errType;
  dynamic statusCode;
  GetAllSpecificationsStateFaild({this.msg, this.errType,this.statusCode});
}
