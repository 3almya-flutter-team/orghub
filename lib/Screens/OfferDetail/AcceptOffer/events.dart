import 'package:flutter/foundation.dart';

class AcceptOfferEvents {}

class AcceptOfferEventsStart extends AcceptOfferEvents {
  int offerId;
  AcceptOfferEventsStart({
    @required this.offerId,
  });
}
