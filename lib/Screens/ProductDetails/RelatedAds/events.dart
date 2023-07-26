import 'package:flutter/foundation.dart';

class GetRelatedAdvertsEvents {}

class GetRelatedAdvertsEventsStart extends GetRelatedAdvertsEvents {
  int advertId;
  GetRelatedAdvertsEventsStart({
    @required this.advertId,
  });
}

class GetRelatedAdvertsEventsSuccess extends GetRelatedAdvertsEvents {}

class GetRelatedAdvertsEventsFailed extends GetRelatedAdvertsEvents {}
