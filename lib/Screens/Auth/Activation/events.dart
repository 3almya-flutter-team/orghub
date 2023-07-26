class ActivateAccountEvents {}

class ActivateAccountEventsStart extends ActivateAccountEvents {
  String phone;
  String code;
  ActivateAccountEventsStart({
    this.code,
    this.phone,
  });
}

class ActivateAccountEventsSuccess extends ActivateAccountEvents {}

class ActivateAccountEventsFailed extends ActivateAccountEvents {}
