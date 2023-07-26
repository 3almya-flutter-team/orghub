import 'package:flutter/material.dart';
// import 'package:orghub/ComonServices/CityService/model.dart';
import 'package:orghub/Screens/Home/AllSliders/model.dart';

class GetAllSlidersStates {}

class GetAllSlidersStateStart extends GetAllSlidersStates {}

class GetAllSlidersStateSucess extends GetAllSlidersStates {
  List<SliderData> allSliders;
  GetAllSlidersStateSucess({
    @required this.allSliders,
  });
}

class GetAllSlidersStateFaild extends GetAllSlidersStates {
  String msg;
  int errType;
  dynamic statusCode;
  GetAllSlidersStateFaild({this.msg, this.errType,this.statusCode});
}
