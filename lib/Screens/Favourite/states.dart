import 'package:flutter/cupertino.dart';
import 'package:orghub/Screens/Favourite/model.dart';

class GetAllFavAdsStates {}

class GetAllFavAdsStatesStart extends GetAllFavAdsStates {}

class GetAllFavAdsStatesSuccess extends GetAllFavAdsStates {
  List<FavAdData> allFavAdverts;
  GetAllFavAdsStatesSuccess({
    @required this.allFavAdverts,
  });
}

// class GetAllFavAdsStatesCompleted extends GetAllFavAdsStates {
//   List<FavAdData> allFavs;
//   bool empty;
//   bool hasReachedPageMax;
//   bool hasReachedEndOfResults;
//   GetAllFavAdsStatesCompleted(
//       {this.allFavs,
//       this.hasReachedEndOfResults,
//       this.hasReachedPageMax,
//       this.empty});
// }

class GetAllFavAdsStatesFailed extends GetAllFavAdsStates {
  int errType;
  dynamic statusCode;
  String msg;
  GetAllFavAdsStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
