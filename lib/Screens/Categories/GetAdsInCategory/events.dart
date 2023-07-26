import 'package:flutter/material.dart';

class GetCategoryAdsEvents {}

class GetCategoryAdsEventsStart extends GetCategoryAdsEvents {
  int catId;
  String adType;
  GetCategoryAdsEventsStart({
    @required this.catId,
    @required this.adType,
  });
}
