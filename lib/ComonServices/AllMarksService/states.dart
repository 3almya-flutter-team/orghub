import 'package:orghub/ComonServices/AllMarksService/model.dart';

class GetAllMarksStates {}

class GetAllMarksStateStart extends GetAllMarksStates {}

class GetAllMarksStateSucess extends GetAllMarksStates {
  AllMarksModel allMarksModel;
  GetAllMarksStateSucess({
    this.allMarksModel,
  });
}

class GetAllMarksStateFaild extends GetAllMarksStates {
  String msg;
  int errType;
  GetAllMarksStateFaild({this.msg, this.errType});
}
