class GetAllChatsEvents {}

class GetAllChatsEventsStart extends GetAllChatsEvents {
  String term;
  int pageNum;
  GetAllChatsEventsStart({
    this.term,
    this.pageNum,
  });
}

class GetAllChatsSearchEventStart extends GetAllChatsEvents {
  String term;
  int pageNum;
  GetAllChatsSearchEventStart({
    this.term,
    this.pageNum,
  });
}

class GetNextChatsEvent extends GetAllChatsEvents {
  String term;
  int pageNum;
  GetNextChatsEvent({this.term,this.pageNum});
}
