import 'package:flutter/foundation.dart';

class GetUserProductsEvents {}

class GetUserProductsEventsStart extends GetUserProductsEvents {
  int userId;
  GetUserProductsEventsStart({
    @required this.userId,
  });
}

class GetUserProductsEventsSuccess extends GetUserProductsEvents {}

class GetUserProductsEventsFailed extends GetUserProductsEvents {
  int errType;
  String msg;
  GetUserProductsEventsFailed({
    this.errType,
    this.msg,
  });
}
