class GetMostSellingAdvertsEvents {
  String msg;
  String errType;
  GetMostSellingAdvertsEvents({
    this.msg,
    this.errType,
  });
}

class GetMostSellingAdvertsEventsStart extends GetMostSellingAdvertsEvents {}

class GetMostSellingAdvertsEventsSuccess extends GetMostSellingAdvertsEvents {}

class GetMostSellingAdvertsEventsFailed extends GetMostSellingAdvertsEvents {
  String msg;
  String errType;
  GetMostSellingAdvertsEventsFailed({
    this.msg,
    this.errType,
  });
}
