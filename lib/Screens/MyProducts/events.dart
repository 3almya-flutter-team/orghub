class GetMyProductsEvents {}

class GetMyProductsEventsStart extends GetMyProductsEvents {
  int pageNum;
  GetMyProductsEventsStart({
    this.pageNum,
  });
}

class  GetNextMyProductsEvent extends GetMyProductsEvents{
  int pageNum;
  GetNextMyProductsEvent({this.pageNum});
}

class GetMyProductsEventsSuccess extends GetMyProductsEvents {}

class GetMyProductsEventsFailed extends GetMyProductsEvents {
  int errType;
  String msg;
  GetMyProductsEventsFailed({
    this.errType,
    this.msg,
  });
}
