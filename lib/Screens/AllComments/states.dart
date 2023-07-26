import 'package:flutter/cupertino.dart';
import 'package:orghub/Screens/MyComments/model.dart';

class GetAllAdsCommentsStates {}

class GetAllAdsCommentsStatesStart extends GetAllAdsCommentsStates {
  
}
class GetAllAdsCommentsStatesSuccess extends GetAllAdsCommentsStates {
  List<CommentData> myComments;
  GetAllAdsCommentsStatesSuccess({
    @required this.myComments,
  });
}

class GetAllAdsCommentsStatesFailed extends GetAllAdsCommentsStates {
  int errType;
  String msg;
  dynamic statusCode;
  GetAllAdsCommentsStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
