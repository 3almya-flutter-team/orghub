import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/ProductDetails/AdReviews/events.dart';
import 'package:orghub/Screens/ProductDetails/AdReviews/model.dart';
import 'package:orghub/Screens/ProductDetails/AdReviews/states.dart';

class GetSomeAdvertReviewsBloc
    extends Bloc<GetSomeAddReviewEvents, GetSomeAddReviewStates> {
  GetSomeAdvertReviewsBloc() : super(GetSomeAddReviewStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<GetSomeAddReviewStates> mapEventToState(
      GetSomeAddReviewEvents event) async* {
    if (event is GetSomeAddReviewEventsSatart) {
      yield GetSomeAddReviewStatesStart();
      CustomResponse response =
          await getSomeAdReviews(advertId: event.advertId);
      if (response.success) {
        AdReviewsModel adReviewsModel =
            AdReviewsModel.fromJson(response.response.data);
        yield GetSomeAddReviewStatesSuccess(addReviews: adReviewsModel.data);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetSomeAddReviewStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetSomeAddReviewStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield GetSomeAddReviewStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> getSomeAdReviews({@required int advertId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/ads/$advertId/reviews?page=1",
      headers: {
        "Accept": "application/json",
        "Authorization": await Prefs.getStringF("authToken"),
      },
    );
    return response;
  }
}
