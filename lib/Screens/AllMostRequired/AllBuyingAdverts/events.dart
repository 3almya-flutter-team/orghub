class GetAllBuyingAdvertsEvents {}
class GetAllBuyingAdvertsEventsStart extends GetAllBuyingAdvertsEvents {
  int pageNum;
  GetAllBuyingAdvertsEventsStart({this.pageNum});
}
class GetAllNextBuyingAdvertsEvents extends GetAllBuyingAdvertsEvents {
  int pageNum;
  GetAllNextBuyingAdvertsEvents({this.pageNum});
}
class GetAllBuyingAdvertsEventsSuccess extends GetAllBuyingAdvertsEvents {}
class GetAllBuyingAdvertsEventsFailed extends GetAllBuyingAdvertsEvents {}
