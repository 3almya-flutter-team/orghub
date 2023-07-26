import 'package:flutter/foundation.dart';

class GetAddressEvents {}

class GetAddressEventStart extends GetAddressEvents {
  double lat;
  double long;
  
  GetAddressEventStart({
    
    @required this.lat,
    @required this.long,
  });
}

