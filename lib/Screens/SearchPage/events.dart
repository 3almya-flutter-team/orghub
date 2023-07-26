import 'package:flutter/foundation.dart';

class SearchEvents {}

class OnSearchEventsStart extends SearchEvents {
  Map<String, dynamic> filterData;
  OnSearchEventsStart({@required this.filterData});
}
