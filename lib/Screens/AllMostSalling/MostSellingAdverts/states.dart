import 'package:flutter/material.dart';
import 'package:orghub/Screens/AllMostSalling/MostSellingAdverts/model.dart';

class GetAllSellingAdvertsStates {}

class GetAllSellingAdvertsStatesStart extends GetAllSellingAdvertsStates {}

class GetAllSellingAdvertsStatesSuccess extends GetAllSellingAdvertsStates {
  List<AdvertData> adverts;
  GetAllSellingAdvertsStatesSuccess({
    @required this.adverts,
  });
}

class GetAllSellingAdvertsStatesNoData extends GetAllSellingAdvertsStates {}

class GetAllSellingAdvertsStatesCompleted extends GetAllSellingAdvertsStates {
  List<AdvertData> adverts;
  bool empty;
  bool hasReachedPageMax;
  bool hasReachedEndOfResults;
  GetAllSellingAdvertsStatesCompleted(
      {this.adverts,
      this.hasReachedEndOfResults,
      this.hasReachedPageMax,
      this.empty});
}

class GetAllSellingAdvertsStatesFailed extends GetAllSellingAdvertsStates {
  String msg;
  dynamic statusCode;
  int errType;
  GetAllSellingAdvertsStatesFailed({this.msg, this.errType,this.statusCode});
}

// import 'package:flutter/material.dart';
// import 'package:orghub/Screens/AllMostSalling/MostSellingAdverts/model.dart';

// class GetAllSellingAdvertsStates {}

// class GetAllSellingAdvertsStatesStart extends GetAllSellingAdvertsStates {}

// class GetAllSellingAdvertsStatesSuccess extends GetAllSellingAdvertsStates {
//   List<AdvertData> adverts;
//   GetAllSellingAdvertsStatesSuccess({
//     @required this.adverts,
//   });
// }

// class GetAllSellingAdvertsStatesFailed extends GetAllSellingAdvertsStates {
//   String msg;
//   int errType;
//   GetAllSellingAdvertsStatesFailed({this.msg, this.errType});
// }
