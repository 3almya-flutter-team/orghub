import 'package:orghub/ComonServices/AllClassificationsService/model.dart';

class GetAllClassificationsStates {}

class GetAllClassificationsStateStart extends GetAllClassificationsStates {}

class GetAllClassificationsStateSucess extends GetAllClassificationsStates {
  AllClassificationsModel allClassificationsModel;
  GetAllClassificationsStateSucess({
    this.allClassificationsModel,
  });
}

class GetAllClassificationsStateFaild extends GetAllClassificationsStates {
  String msg;
  int errType;
  dynamic statusCode;
  GetAllClassificationsStateFaild({this.msg, this.errType,this.statusCode});
}
