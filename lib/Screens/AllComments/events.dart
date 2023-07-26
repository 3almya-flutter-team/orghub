import 'package:flutter/foundation.dart';

class GetAllAdsCommentsEvents {}

class GetAllAdsCommentsEventsStart extends GetAllAdsCommentsEvents {
  int advertId;
  GetAllAdsCommentsEventsStart({
    @required this.advertId,
  });
}
