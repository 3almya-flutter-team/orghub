import 'package:flutter/material.dart';
import 'package:orghub/Screens/MyProducts/model.dart';

class GetMyProductsStates {}

class GetMyProductsStatesStart extends GetMyProductsStates {}

class GetMyProductsStatesSuccess extends GetMyProductsStates {
  List<MyProductData> myProducts;
  GetMyProductsStatesSuccess({
    @required this.myProducts,
  });
}

class GetMyProductsStatesNoData extends GetMyProductsStates {}

class GetMyProductsStatesCompleted extends GetMyProductsStates {
  List<MyProductData> myProducts;
  bool empty;
  bool hasReachedPageMax;
  bool hasReachedEndOfResults;
  GetMyProductsStatesCompleted(
      {this.myProducts,
      this.hasReachedEndOfResults,
      this.hasReachedPageMax,
      this.empty});
}

class GetMyProductsStatesFailed extends GetMyProductsStates {
  int errType;
  dynamic statusCode;
  String msg;
  GetMyProductsStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
