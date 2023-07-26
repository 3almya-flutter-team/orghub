import 'package:flutter/foundation.dart';

class DeleteOfferEvents {}

class DeleteOfferEventsStart extends DeleteOfferEvents {
  int offerId;
  DeleteOfferEventsStart({
    @required this.offerId,
  });
}
