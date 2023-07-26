import 'package:orghub/ComonServices/AllTagsService/model.dart';

class GetAllTagsStates {}

class GetAllTagsStateStart extends GetAllTagsStates {}

class GetAllTagsStateSucess extends GetAllTagsStates {
  AllTagsModel allTagsModel;
  GetAllTagsStateSucess({
    this.allTagsModel,
  });
}

class GetAllTagsStateFaild extends GetAllTagsStates {
  String msg;
  dynamic statusCode;
  int errType;
  GetAllTagsStateFaild({this.msg, this.errType, this.statusCode});
}
