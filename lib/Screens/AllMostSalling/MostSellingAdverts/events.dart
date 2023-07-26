class GetAllSellingAdvertsEvents {}
class GetAllSellingAdvertsEventsStart extends GetAllSellingAdvertsEvents {
  int pageNum;
  GetAllSellingAdvertsEventsStart({this.pageNum});
}
class GetAllNextSellingAdvertsEvents extends GetAllSellingAdvertsEvents {
  int pageNum;
  GetAllNextSellingAdvertsEvents({this.pageNum});
}
class GetAllSellingAdvertsEventsSuccess extends GetAllSellingAdvertsEvents {}
class GetAllSellingAdvertsEventsFailed extends GetAllSellingAdvertsEvents {}




// class GetAllSellingAdvertsEvents {}
// class GetAllSellingAdvertsEventsStart extends GetAllSellingAdvertsEvents {}
// class GetAllSellingAdvertsEventsSuccess extends GetAllSellingAdvertsEvents {}
// class GetAllSellingAdvertsEventsFailed extends GetAllSellingAdvertsEvents {}
