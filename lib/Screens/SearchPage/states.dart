import 'package:flutter/cupertino.dart';
import 'package:orghub/Screens/SearchPage/model.dart';

class SearchStates {}

class OnSearchStatesStart extends SearchStates {}

class OnSearchStatesSuccess extends SearchStates {
  List<SearchItem> searchResults;
  OnSearchStatesSuccess({
    @required this.searchResults,
  });
}

class OnSearchStatesFailed extends SearchStates {
  int errType;
  dynamic statusCode;
  String msg;
  OnSearchStatesFailed({
    this.errType,
    this.statusCode,
    this.msg,
  });
}
