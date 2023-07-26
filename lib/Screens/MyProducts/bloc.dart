import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/MyProducts/events.dart';
import 'package:orghub/Screens/MyProducts/model.dart';
import 'package:orghub/Screens/MyProducts/states.dart';

class GetMyProductsBloc extends Bloc<GetMyProductsEvents, GetMyProductsStates> {
  GetMyProductsBloc() : super(GetMyProductsStates());

  ServerGate serverGate = ServerGate();

  List<MyProductData> myProducts = [];

  @override
  Stream<GetMyProductsStates> mapEventToState(
      GetMyProductsEvents event) async* {
    if (event is GetMyProductsEventsStart) {
      yield GetMyProductsStatesStart();
      CustomResponse response =
          await fetchMyAllProducts(pageNum: event.pageNum);
      if (response.success) {
        MyAdsModel myAdsModel = MyAdsModel.fromJson(response.response.data);
        myProducts.addAll(myAdsModel.data);

        if (myAdsModel.meta.total == 0) {
          yield GetMyProductsStatesNoData();
        } else {
          yield GetMyProductsStatesCompleted(
            empty: false,
            myProducts: myProducts,
            hasReachedPageMax:
                myAdsModel.data.length < myAdsModel.meta.perPage ? true : false,
            hasReachedEndOfResults: false,
          );
        }
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetMyProductsStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetMyProductsStatesFailed(
            errType: 1,
             statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetMyProductsStatesFailed(
            errType: 2,
             statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    } else if (event is GetNextMyProductsEvent) {
      CustomResponse response =
          await fetchMyAllProducts(pageNum: event.pageNum);

      if (response.success) {
        MyAdsModel myAdsModel = MyAdsModel.fromJson(response.response.data);
        myProducts.addAll(myAdsModel.data);

        if (myAdsModel.meta.lastPage > 0 &&
            (myAdsModel.meta.currentPage >= myAdsModel.meta.lastPage)) {
          yield GetMyProductsStatesCompleted(
            empty: false,
            myProducts: myProducts,
            hasReachedPageMax:
                myAdsModel.data.length < myAdsModel.meta.perPage ? true : false,
            hasReachedEndOfResults: true,
          );
        } else {
          yield GetMyProductsStatesCompleted(
            empty: false,
            myProducts: myProducts,
            hasReachedPageMax:
                myAdsModel.data.length < myAdsModel.meta.perPage ? true : false,
            hasReachedEndOfResults: false,
          );
        }
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetMyProductsStatesFailed(
            errType: response.errType,
             statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetMyProductsStatesFailed(
            errType: response.errType,
             statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetMyProductsStatesFailed(
            errType: response.errType,
             statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchMyAllProducts({int pageNum}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: "client/my_ads?page=$pageNum",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
