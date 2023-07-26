import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/ProductDetails/AddFavorite/events.dart';
import 'package:orghub/Screens/ProductDetails/AddFavorite/model.dart';
import 'package:orghub/Screens/ProductDetails/AddFavorite/states.dart';

class AddAdvertToFavBloc
    extends Bloc<AddAdvertToFavEvents, AddAdvertToFavStates> {
  ServerGate serverGate = ServerGate();
  AddAdvertToFavBloc() : super(AddAdvertToFavStates());

  @override
  Stream<AddAdvertToFavStates> mapEventToState(
      AddAdvertToFavEvents event) async* {
    if (event is AddAdvertToFavEvevntsStart) {
      yield AddAdvertToFavStatesStart();

      CustomResponse response = await addOrRemoveAdvertToFav(
        advertId: event.advertId,
      );

      if (response.success) {
        print("response => ${response.response.data.toString()}");
        AddToFavModel addToFavModel =
            AddToFavModel.fromJson(response.response.data);
        yield AddAdvertToFavStatesSuccess(favAdvertData: addToFavModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield AddAdvertToFavStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error['message']}");
          yield AddAdvertToFavStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield AddAdvertToFavStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> addOrRemoveAdvertToFav({
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
