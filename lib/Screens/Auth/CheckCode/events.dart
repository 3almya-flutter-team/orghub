class CheckCodeEvents {}

class CheckCodeEventsStart extends CheckCodeEvents {
  String phone;
  String code;
  CheckCodeEventsStart({
    this.code,
    this.phone,
  });
}

class CheckCodeEventsSuccess extends CheckCodeEvents {}

class CheckCodeEventsFailed extends CheckCodeEvents {}
