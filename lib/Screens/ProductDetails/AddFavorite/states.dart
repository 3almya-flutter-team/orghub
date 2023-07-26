import 'package:flutter/cupertino.dart';
import 'package:orghub/Screens/ProductDetails/AddFavorite/model.dart';

class AddAdvertToFavStates {}

class AddAdvertToFavStatesStart extends AddAdvertToFavStates {}

class AddAdvertToFavStatesSuccess extends AddAdvertToFavStates {
  FavAdvertData favAdvertData;
  AddAdvertToFavStatesSuccess({
    @required this.favAdvertData,
  });
}

class AddAdvertToFavStatesFailed extends AddAdvertToFavStates {
  String msg;
  int errType;
  AddAdvertToFavStatesFailed({this.msg, this.errType});
}
