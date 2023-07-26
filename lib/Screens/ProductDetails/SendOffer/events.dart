import 'package:flutter/cupertino.dart';

class SendOfferEvents {}

class SendOfferEventsStart extends SendOfferEvents {
  Map<String, dynamic> offerData;
  SendOfferEventsStart({
    @required this.offerData,
  });
}
