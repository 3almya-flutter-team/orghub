import 'package:flutter/cupertino.dart';

class RemoveFromFavEvents {}

class RemoveFromFavEventsStart extends RemoveFromFavEvents{
  int advertId;
  RemoveFromFavEventsStart({
    @required this.advertId,
  });
}
