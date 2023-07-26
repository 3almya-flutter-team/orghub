import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Favourite/RemoveFromFav/events.dart';
import 'package:orghub/Screens/Favourite/RemoveFromFav/states.dart';
import 'package:orghub/Screens/ProductDetails/AddFavorite/model.dart';

class RemoveFromFavBloc
    extends Bloc<RemoveFromFavEvents, RemoveFromFavStates> {
  ServerGate serverGate = ServerGate();
  RemoveFromFavBloc() : super(RemoveFromFavStates());

  @override
  Stream<RemoveFromFavStates> mapEventToState(
      RemoveFromFavEvents event) async* {
    if (event is RemoveFromFavEventsStart) {
      yield RemoveFromFavStatesStart();

      CustomResponse response = await removeAdvertFromFav(
        advertId: event.advertId,
      );

      if (response.success) {
        print("response => ${response.response.data.toString()}");
        AddToFavModel addToFavModel =
            AddToFavModel.fromJson(response.response.data);
        yield RemoveFromFavStatesSuccess(removedAdId: addToFavModel.data.id);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield RemoveFromFavStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield RemoveFromFavStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield RemoveFromFavStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> removeAdvertFromFav({
    @required int advertId,
  }) async {
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "favourites",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
      body: {
        "ad_id": advertId,
      },
    );

    return response;
  }
}
