
class SelectOtherServiceState {}

class SelectOtherServiceStateStart extends SelectOtherServiceState {}

class SelectOtherServiceStateSuccess extends SelectOtherServiceState {}

class SelectOtherServiceStateFailed extends SelectOtherServiceState {
  int errType;
  String msg;
  SelectOtherServiceStateFailed({
    this.errType,
    this.msg,
  });
}
